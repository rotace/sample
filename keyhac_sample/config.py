# -*- mode: python; coding: utf-8-dos -*-

##
## Windows の操作を emacs のキーバインドで行うための設定（keyhac版）ver.20151121_01
##

# このスクリプトは、keyhac で動作します。
#   https://sites.google.com/site/craftware/keyhac
# スクリプトですので、使いやすいようにカスタマイズしてご利用ください。
#
# この内容は、utf-8-dos の coding-system で config.py の名前でセーブして利用してください。
# また、日本語キーボードか英語キーボードかの指定をスクリプトの最初の方にある is_japanese_keybord
# という変数の設定で行ってください。（初期値は、日本語キーボードとなっています。）
#
# emacs の挙動と明らかに違う動きの部分は以下のとおりです。
# ・左の Ctrlキー と Altキー のみが、emacs用のキーとして認識される。
# ・ESC の二回押下で、ESC が入力される。
# ・C-o または C-\ で、IME の切り替えが行われる。
# ・C-c、C-z は、Windows の「コピー」、「取り消し」が機能するようにしている。
# ・C-k を連続して実行しても、クリップボードへの削除文字列の蓄積は行われない。
#   C-u による行数指定をすると、削除行を一括してクリップボードに入れることができる。
# ・C-l は、アプリケーションソフト個別対応とする。recenter 関数で個別に指定すること。
#   この設定では、Sakura Editor のみ対応している。
# ・キーボードマクロは emacs の挙動と異なり、IME の変換キーも含めた入力したキー
#   そのものを記録する。このため、キーボードマクロ記録時や再生時、IMEの状態に留意した
#   利用が必要。
# ・[A-Z]キーを C-S- 付きで押した時は、S- をとったキー（C-[A-Z]）が Windows に入力される。
#   （IME 独自設定のコントロールキーを利用する際に便利。）
# ・C-x C-y または A-y で、クリップボードリストを起動する。
#  （C-f、C-b でリストの変更、C-n、C-p でリスト内を移動し、Enter で確定する。
#    C-s、C-r で検索も可能。migemo 辞書を登録してあれば、検索文字を大文字で始める
#    ことで migemo 検索も可能。emacs キーバインドを適用しないアプリケーションソフト
#    でも A-y でクリップボードリストは起動し、選択した項目を Enter で確定することで、
#    クリップボードへの格納（テキストの貼り付けではない）が行われる。）
# ・A-l でランチャー用リストを起動する。
#  （全てのアプリケーションソフトで利用可能。操作方法は、クリップボードリストと同じ。）
# ・C-x o は、一つ前にフォーカスがあったウインドウに移動する。
#   NTEmacs の機能やランチャーの機能から Windowsアプリケーションソフトを起動した際に、
#   起動元のアプリケーションソフトに戻るのに便利。

import re

from time    import sleep
from keyhac  import *
from os.path import basename

def configure(keymap):

    ####################################################################################################
    ## 基本設定
    ####################################################################################################

    # 日本語キーボードかどうかを指定する（True: 日本語キーボード、False: 英語キーボード）
    is_japanese_keybord = True

    # shell_command 関数で起動するアプリケーションソフトを指定する
    # （パスが通っていない場所にあるコマンドは、絶対パスで指定してください）
    command_name = r"cmd.exe"

    # emacs のキーバインドに"したくない"アプリケーションソフトを指定する（False を返す）
    # （keyhac のメニューから「内部ログ」を ON にすると processname や classname を確認することができます）
    def is_emacs_target(window):
        if window.getClassName() == "keyhacWindowClass":
            return False

        if window.getProcessName() in (
                                       "explorer.exe",
                                       "powershell.exe",
                                       "notepad.exe",
                                       "ONENOTE.EXE",
                                       "WINWORD.EXE",
                                       "EXCEL.EXE",
                                       "MATLAB.exe",
                                       "chrome.exe"):

            keymap.window_keybind = "emacs"
            return True

        else:
            keymap.window_keybind = "not_emacs"
            return False

    # input method の切り替え"のみをしたい"アプリケーションソフトを指定する（True を返す）
    # （指定できるアプリケーションソフトは、is_emacs_target で除外指定したものからのみとしてください）
    def is_im_target(window):
        if window.getProcessName() in ("cmd.exe",            # cmd
                                       "mintty.exe",         # mintty
                                       "gvim.exe",           # GVim
                                       # "eclipse.exe",        # Eclipse
                                       # "firefox.exe",        # firefox
                                       "xyzzy.exe",          # xyzzy
                                       "putty.exe",          # PuTTY
                                       "ttermpro.exe",       # TeraTerm
                                       "MobaXterm.exe"):     # MobaXterm
            return True
        return False

    keymap_emacs = keymap.defineWindowKeymap(check_func=is_emacs_target)
    keymap_im    = keymap.defineWindowKeymap(check_func=is_im_target)

    # mark がセットされると True になる
    keymap_emacs.is_marked = False

    # 検索が開始されると True になる
    keymap_emacs.is_searching = False

    # キーボードマクロの play 中 は True になる
    keymap_emacs.is_playing_kmacro = False

    # universal-argument コマンドが実行されると True になる
    keymap_emacs.is_universal_argument = False

    # digit-argument コマンドが実行されると True になる
    keymap_emacs.is_digit_argument = False

    # コマンドのリピート回数を設定する
    keymap_emacs.repeat_counter = 1

    # undo のモードの時 True になる（redo のモードの時 False になる）
    keymap_emacs.is_undo_mode = True

    ##################################################
    ## IMEの切替え
    ##################################################

    def toggle_input_method():
        keymap.command_InputKey("A-(25)")()
        if 1:
            if not keymap_emacs.is_playing_kmacro:
                sleep(0.05) # delay

                # IME の状態を取得する
                if keymap.wnd.getImeStatus():
                    message = "[あ]"
                else:
                    message = "[A]"

                # IMEの状態をバルーンヘルプで表示する
                keymap.popBalloon("ime_status", message, 500)

    ##################################################
    ## ファイル操作
    ##################################################

    def find_file():
        keymap.command_InputKey("C-o")()

    def save_buffer():
        keymap.command_InputKey("C-s")()

    def write_file():
        keymap.command_InputKey("A-f", "A-a")()

    def dired():
        keymap.command_ShellExecute(None, r"explorer.exe", "", "")()

    ##################################################
    ## カーソル移動
    ##################################################

    def backward_char():
        keymap.command_InputKey("Left")()

    def forward_char():
        keymap.command_InputKey("Right")()

    def backward_word():
        keymap.command_InputKey("C-Left")()

    def forward_word():
        keymap.command_InputKey("C-Right")()

    def previous_line():
        keymap.command_InputKey("Up")()

    def next_line():
        keymap.command_InputKey("Down")()

    def move_beginning_of_line():
        keymap.command_InputKey("Home")()

    def move_end_of_line():
        keymap.command_InputKey("End")()
        if keymap.getWindow().getClassName() == "_WwG": # Microsoft Word
            if keymap_emacs.is_marked:
                keymap.command_InputKey("Left")()

    def beginning_of_buffer():
        keymap.command_InputKey("C-Home")()

    def end_of_buffer():
        keymap.command_InputKey("C-End")()

    def scroll_up():
        keymap.command_InputKey("PageUp")()

    def scroll_down():
        keymap.command_InputKey("PageDown")()

    def recenter():
        if keymap.getWindow().getClassName() == "EditorClient": # Sakura Editor
            keymap.command_InputKey("C-h")()

    ##################################################
    ## カット / コピー / 削除 / アンドゥ
    ##################################################

    def delete_backward_char():
        keymap.command_InputKey("Back")()

    def delete_char():
        keymap.command_InputKey("Delete")()

    def backward_kill_word(repeat=1):
        keymap_emacs.is_marked = True
        def move_beginning_of_region():
            for i in range(repeat):
                backward_word()
        mark(move_beginning_of_region)()
        delay(kill_region)()

    def kill_word(repeat=1):
        keymap_emacs.is_marked = True
        def move_end_of_region():
            for i in range(repeat):
                forward_word()
        mark(move_end_of_region)()
        delay(kill_region)()

    def kill_line(repeat=1):
        keymap_emacs.is_marked = True
        if repeat == 1:
            mark(move_end_of_line)()
            delay(keymap.command_InputKey("C-c", "Delete"))() # 改行を消せるようにするため C-x にはしていない
        else:
            def move_end_of_region():
                if keymap.getWindow().getClassName() == "_WwG": # Microsoft Word
                    for i in range(repeat):
                        next_line()
                    move_beginning_of_line()
                else:
                    for i in range(repeat - 1):
                        next_line()
                    move_end_of_line()
                    forward_char()
            mark(move_end_of_region)()
            delay(kill_region)()

    def kill_region():
        keymap.command_InputKey("C-x")()

    def kill_ring_save():
        keymap.command_InputKey("C-c")()
        if keymap.getWindow().getClassName() == "EditorClient": # Sakura Editor
            # 選択されているリージョンのハイライトを解除するために Esc を発行する
            keymap.command_InputKey("Esc")()

    def yank():
        keymap.command_InputKey("C-v")()

    def undo():
        # redo（C-y）の機能を持っていないアプリケーションソフトは常に undo とする
        if keymap.getWindow().getClassName() in ("Edit"): # NotePad
            keymap.command_InputKey("C-z")()
        else:
            if keymap_emacs.is_undo_mode:
                keymap.command_InputKey("C-z")()
            else:
                keymap.command_InputKey("C-y")()

    def set_mark_command():
        if keymap_emacs.is_marked:
            keymap_emacs.is_marked = False
        else:
            keymap_emacs.is_marked = True

    def mark_whole_buffer():
        if keymap.getWindow().getClassName().startswith("EXCEL"): # Microsoft Excel
            # Excel のセルの中でも機能するようにする対策
            keymap.command_InputKey("C-End", "C-S-Home")()
        else:
            keymap.command_InputKey("C-Home", "C-a")()

    def mark_page():
        mark_whole_buffer()

    def open_line():
        keymap.command_InputKey("Enter", "Up", "End")()

    ##################################################
    ## バッファ / ウインドウ操作
    ##################################################

    def kill_buffer():
        keymap.command_InputKey("C-F4")()

    def switch_to_buffer():
        keymap.command_InputKey("C-Tab")()

    def other_window():
        tl_wnd = keymap.getTopLevelWindow()
        wnd = tl_wnd.getNext()
        while wnd:
            if wnd.isVisible() and not wnd.getOwner() and wnd != tl_wnd.getOwner() and \
               wnd.getClassName() != "Shell_TrayWnd":
                wnd.getLastActivePopup().setForeground()
                break
            wnd = wnd.getNext()

    ##################################################
    ## 文字列検索 / 置換
    ##################################################

    def isearch(direction):
        if keymap_emacs.is_searching:
            if keymap.getWindow().getProcessName() == "EXCEL.EXE":  # Microsoft Excel
                if keymap.getWindow().getClassName() == "EDTBX": # 検索ウィンドウ
                    keymap.command_InputKey({"backward":"A-S-f", "forward":"A-f"}[direction])()
                else:
                    keymap.command_InputKey("C-f")()
            else:
                keymap.command_InputKey({"backward":"S-F3", "forward":"F3"}[direction])()
        else:
            keymap.command_InputKey("C-f")()
            keymap_emacs.is_searching = True

    def isearch_backward():
        isearch("backward")

    def isearch_forward():
        isearch("forward")

    def query_replace():
        keymap.command_InputKey("C-h")()

    ##################################################
    ## キーボードマクロ
    ##################################################

    def kmacro_start_macro():
        keymap.command_RecordStart()

    def kmacro_end_macro():
        keymap.command_RecordStop()
        # キーボードマクロの終了キー C-x ) の C-x がマクロに記録されてしまうのを削除する
        # キーボードマクロの終了キーの前提を C-x ) としていることについては、とりえず了承ください
        if len(keymap.record_seq) >= 4:
            if (((keymap.record_seq[len(keymap.record_seq) - 1] == (162, True) and   # U-LCtrl
                  keymap.record_seq[len(keymap.record_seq) - 2] == ( 88, True)) or   # U-X
                 (keymap.record_seq[len(keymap.record_seq) - 1] == ( 88, True) and   # U-X
                  keymap.record_seq[len(keymap.record_seq) - 2] == (162, True))) and # U-LCtrl
                keymap.record_seq[len(keymap.record_seq) - 3] == (88, False)):       # D-X
                   keymap.record_seq.pop()
                   keymap.record_seq.pop()
                   keymap.record_seq.pop()
                   if keymap.record_seq[len(keymap.record_seq) - 1] == (162, False): # D-LCtrl
                       for i in range(len(keymap.record_seq) - 1, -1, -1):
                           if keymap.record_seq[i] == (162, False): # D-LCtrl
                               keymap.record_seq.pop()
                           else:
                               break
                   else:
                       # コントロール系の入力が連続して行われる場合があるための対処
                       keymap.record_seq.append((162, True)) # U-LCtrl

    def kmacro_end_and_call_macro():
        keymap_emacs.is_playing_kmacro = True
        keymap.command_RecordPlay()
        keymap_emacs.is_playing_kmacro = False

    ##################################################
    ## その他
    ##################################################

    def newline():
        keymap.command_InputKey("Enter")()

    def newline_and_indent():
        keymap.command_InputKey("Enter", "Tab")()

    def indent_for_tab_command():
        keymap.command_InputKey("Tab")()

    def keybord_quit():
        if not keymap.getWindow().getClassName().startswith("EXCEL"): # Microsoft Excel 以外
            # 選択されているリージョンのハイライトを解除するために Esc を発行しているが、
            # アプリケーションソフトによっては効果なし
            keymap.command_InputKey("Esc")()
        keymap.command_RecordStop()
        if keymap_emacs.is_undo_mode:
            keymap_emacs.is_undo_mode = False
        else:
            keymap_emacs.is_undo_mode = True

    def kill_emacs():
        keymap.command_InputKey("A-F4")()

    def universal_argument():
        if keymap_emacs.is_universal_argument:
            if keymap_emacs.is_digit_argument == True:
                keymap_emacs.is_universal_argument = False
            else:
                keymap_emacs.repeat_counter *= 4
        else:
            keymap_emacs.is_universal_argument = True
            keymap_emacs.repeat_counter *= 4

    def digit_argument(number):
        if keymap_emacs.is_digit_argument:
            keymap_emacs.repeat_counter = keymap_emacs.repeat_counter * 10 + number
        else:
            keymap_emacs.repeat_counter = number
            keymap_emacs.is_digit_argument = True

    def shell_command():
        def popCommandWindow(wnd, command):
            if wnd.isVisible() and not wnd.getOwner() and wnd.getProcessName() == command:
                if wnd.isMinimized():
                    wnd.restore()
                wnd.getLastActivePopup().setForeground()
                keymap_emacs.is_executing_command = True
                return False
            return True

        keymap_emacs.is_executing_command = False
        Window.enum(popCommandWindow, basename(command_name))

        if not keymap_emacs.is_executing_command:
            keymap.command_ShellExecute(None, command_name, "", "")()

    ##################################################
    ## 共通関数
    ##################################################

    def self_insert_command(key):
        return keymap.command_InputKey(key)

    def digit(number):
        def _func():
            if keymap_emacs.is_universal_argument:
                digit_argument(number)
            else:
                reset_undo(reset_counter(reset_mark(repeat(keymap.command_InputKey(str(number))))))()
        return _func

    def digit2(number):
        def _func():
            keymap_emacs.is_universal_argument = True
            digit_argument(number)
        return _func

    def delay(func, sec=0.01):
        def _func():
            sleep(sec) # delay
            func()
            sleep(sec) # delay
        return _func

    def mark(func):
        def _func():
            if keymap_emacs.is_marked:
                # D-Shift だと、M-< や M-> 押下時に、D-Shift が解除されてしまう。その対策。
                keymap.command_InputKey("D-LShift", "D-RShift")()
                delay(func)()
                keymap.command_InputKey("U-LShift", "U-RShift")()
            else:
                func()
        return _func

    def reset_mark(func):
        def _func():
            func()
            keymap_emacs.is_marked = False
        return _func

    def reset_counter(func):
        def _func():
            func()
            keymap_emacs.is_universal_argument = False
            keymap_emacs.is_digit_argument = False
            keymap_emacs.repeat_counter = 1
        return _func

    def reset_undo(func):
        def _func():
            func()
            keymap_emacs.is_undo_mode = True
        return _func

    def reset_search(func):
        def _func():
            func()
            keymap_emacs.is_searching = False
        return _func

    def repeat(func):
        def _func():
            # 以下の２行は、キーボードマクロの繰り返し実行の際に必要な設定
            repeat_counter = keymap_emacs.repeat_counter
            keymap_emacs.repeat_counter = 1
            for i in range(repeat_counter):
                func()
        return _func

    def repeat2(func):
        def _func():
            if keymap_emacs.is_marked:
                keymap_emacs.repeat_counter = 1
            repeat(func)()
        return _func

    def repeat3(func):
        def _func():
            func(keymap_emacs.repeat_counter)
        return _func

    ##################################################
    ## キーバインド
    ##################################################

    # http://homepage3.nifty.com/ic/help/rmfunc/vkey.htm
    # http://www.azaelia.net/factory/vk.html
    # http://www.yoshidastyle.net/2007/10/windowswin32api.html

    ## マルチストロークキーの設定
    keymap_emacs["Esc"]            = keymap.defineMultiStrokeKeymap("Esc")
    keymap_emacs["LC-OpenBracket"] = keymap.defineMultiStrokeKeymap("C-OpenBracket")
    keymap_emacs["LC-x"]           = keymap.defineMultiStrokeKeymap("C-x")
    keymap_emacs["LC-q"]           = keymap.defineMultiStrokeKeymap("C-q")

    ## [0-9]キーの設定
    for key in range(10):
        s_key = str(key)
        keymap_emacs[        s_key]           = digit(key)
        keymap_emacs["LC-" + s_key]           = digit2(key)
        keymap_emacs["LA-" + s_key]           = digit2(key)
        keymap_emacs["Esc"][ s_key]           = keymap_emacs["LA-" + s_key]
        keymap_emacs["LC-OpenBracket"][s_key] = keymap_emacs["LA-" + s_key]
        keymap_emacs["S-" + s_key] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command("S-" + s_key)))))

    ## SPACE, [A-Z]キーの設定
    for vkey in [32] + list(range(65, 90 + 1)):
        s_vkey = str(vkey)
        keymap_emacs[  "(" + s_vkey + ")"] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command(  "(" + s_vkey + ")")))))
        keymap_emacs["S-(" + s_vkey + ")"] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command("S-(" + s_vkey + ")")))))

    ## 10key の特殊文字キーの設定
    for vkey in [106, 107, 109, 110, 111]:
        s_vkey = str(vkey)
        keymap_emacs[  "(" + s_vkey + ")"] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command(  "(" + s_vkey + ")")))))

    ## 特殊文字キーの設定
    for vkey in list(range(186, 192 + 1)) + list(range(219, 222 + 1)) + [226]:
        s_vkey = str(vkey)
        keymap_emacs[  "(" + s_vkey + ")"] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command(  "(" + s_vkey + ")")))))
        keymap_emacs["S-(" + s_vkey + ")"] = reset_undo(reset_counter(reset_mark(repeat(self_insert_command("S-(" + s_vkey + ")")))))

    ## quoted-insertキーの設定
    for vkey in range(1, 255):
        s_vkey = str(vkey)
        keymap_emacs["LC-q"][  "("   + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command(  "("   + s_vkey + ")")))))
        keymap_emacs["LC-q"]["S-("   + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("S-("   + s_vkey + ")")))))
        keymap_emacs["LC-q"]["C-("   + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("C-("   + s_vkey + ")")))))
        keymap_emacs["LC-q"]["C-S-(" + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("C-S-(" + s_vkey + ")")))))
        keymap_emacs["LC-q"]["A-("   + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("A-("   + s_vkey + ")")))))
        keymap_emacs["LC-q"]["A-S-(" + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("A-S-(" + s_vkey + ")")))))

    ## LC-S-[A-Z] -> C-[A-Z] の置き換え設定
    for vkey in range(65, 90 + 1):
        s_vkey = str(vkey)
        keymap_emacs["LC-S-(" + s_vkey + ")"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("C-(" + s_vkey + ")")))))

    ## Esc の二回押しを Esc とする設定
    keymap_emacs["Esc"]["Esc"]                      = reset_undo(reset_counter(self_insert_command("Esc")))
    keymap_emacs["LC-OpenBracket"]["C-OpenBracket"] = keymap_emacs["Esc"]["Esc"]

    ## universal-argumentキーの設定
    keymap_emacs["LC-u"] = universal_argument

    ## 「IMEの切替え」のキー設定
    keymap_emacs["(243)"]   = toggle_input_method
    keymap_emacs["(244)"]   = toggle_input_method
    keymap_emacs["LA-(25)"] = toggle_input_method
    keymap_emacs["LC-Yen"]  = toggle_input_method
    keymap_emacs["LC-o"]    = toggle_input_method # or open_line

    keymap_im["(243)"]   = toggle_input_method
    keymap_im["(244)"]   = toggle_input_method
    keymap_im["LA-(25)"] = toggle_input_method
    keymap_im["LC-Yen"]  = toggle_input_method
    keymap_im["LC-o"]    = toggle_input_method

    ## 「ファイル操作」のキー設定
    keymap_emacs["LC-x"]["C-f"] = reset_search(reset_undo(reset_counter(reset_mark(find_file))))
    keymap_emacs["LC-x"]["C-s"] = reset_search(reset_undo(reset_counter(reset_mark(save_buffer))))
    keymap_emacs["LC-x"]["C-w"] = reset_search(reset_undo(reset_counter(reset_mark(write_file))))
    keymap_emacs["LC-x"]["d"]   = reset_search(reset_undo(reset_counter(reset_mark(dired))))

    ## 「カーソル移動」のキー設定
    keymap_emacs["LC-b"] = reset_search(reset_undo(reset_counter(mark(repeat(backward_char)))))
    keymap_emacs["LC-f"] = reset_search(reset_undo(reset_counter(mark(repeat(forward_char)))))

    keymap_emacs["LA-b"]                = reset_search(reset_undo(reset_counter(mark(repeat(backward_word)))))
    keymap_emacs["Esc"]["b"]            = keymap_emacs["LA-b"]
    keymap_emacs["LC-OpenBracket"]["b"] = keymap_emacs["LA-b"]

    keymap_emacs["LA-f"]                = reset_search(reset_undo(reset_counter(mark(repeat(forward_word)))))
    keymap_emacs["Esc"]["f"]            = keymap_emacs["LA-f"]
    keymap_emacs["LC-OpenBracket"]["f"] = keymap_emacs["LA-f"]

    keymap_emacs["LC-p"] = reset_search(reset_undo(reset_counter(mark(repeat(previous_line)))))
    keymap_emacs["LC-n"] = reset_search(reset_undo(reset_counter(mark(repeat(next_line)))))
    keymap_emacs["LC-a"] = reset_search(reset_undo(reset_counter(mark(move_beginning_of_line))))
    keymap_emacs["LC-e"] = reset_search(reset_undo(reset_counter(mark(move_end_of_line))))

    keymap_emacs["LA-S-Comma"]                 = reset_search(reset_undo(reset_counter(mark(beginning_of_buffer))))
    keymap_emacs["Esc"]["S-Comma"]             = keymap_emacs["LA-S-Comma"]
    keymap_emacs["LC-OpenBracket"]["S-Comma"]  = keymap_emacs["LA-S-Comma"]

    keymap_emacs["LA-S-Period"]                = reset_search(reset_undo(reset_counter(mark(end_of_buffer))))
    keymap_emacs["Esc"]["S-Period"]            = keymap_emacs["LA-S-Period"]
    keymap_emacs["LC-OpenBracket"]["S-Period"] = keymap_emacs["LA-S-Period"]

    keymap_emacs["LA-v"]                = reset_search(reset_undo(reset_counter(mark(scroll_up))))
    keymap_emacs["Esc"]["v"]            = keymap_emacs["LA-v"]
    keymap_emacs["LC-OpenBracket"]["v"] = keymap_emacs["LA-v"]

    keymap_emacs["LC-v"] = reset_search(reset_undo(reset_counter(mark(scroll_down))))
    keymap_emacs["LC-l"] = reset_search(reset_undo(reset_counter(recenter)))

    ## 「カット / コピー / 削除 / アンドゥ」のキー設定
    keymap_emacs["LC-h"]    = reset_search(reset_undo(reset_counter(reset_mark(repeat2(delete_backward_char)))))
    keymap_emacs["LC-d"]    = reset_search(reset_undo(reset_counter(reset_mark(repeat2(delete_char)))))
    keymap_emacs["LC-Back"] = reset_search(reset_undo(reset_counter(reset_mark(repeat3(backward_kill_word)))))

    keymap_emacs["LA-Delete"]                = reset_search(reset_undo(reset_counter(reset_mark(repeat3(backward_kill_word)))))
    keymap_emacs["Esc"]["Delete"]            = keymap_emacs["LA-Delete"]
    keymap_emacs["LC-OpenBracket"]["Delete"] = keymap_emacs["LA-Delete"]

    keymap_emacs["LC-Delete"] = reset_search(reset_undo(reset_counter(reset_mark(repeat3(kill_word)))))

    keymap_emacs["LA-d"]                = reset_search(reset_undo(reset_counter(reset_mark(repeat3(kill_word)))))
    keymap_emacs["Esc"]["d"]            = keymap_emacs["LA-d"]
    keymap_emacs["LC-OpenBracket"]["d"] = keymap_emacs["LA-d"]

    keymap_emacs["LC-k"] = reset_search(reset_undo(reset_counter(reset_mark(repeat3(kill_line)))))
    keymap_emacs["LC-w"] = reset_search(reset_undo(reset_counter(reset_mark(kill_region))))

    keymap_emacs["LA-w"]                = reset_search(reset_undo(reset_counter(reset_mark(kill_ring_save))))
    keymap_emacs["Esc"]["w"]            = keymap_emacs["LA-w"]
    keymap_emacs["LC-OpenBracket"]["w"] = keymap_emacs["LA-w"]

    keymap_emacs["LC-c"]      = reset_search(reset_undo(reset_counter(reset_mark(kill_ring_save))))
    keymap_emacs["LC-y"]      = reset_search(reset_undo(reset_counter(reset_mark(yank))))
    keymap_emacs["LC-z"]      = reset_search(reset_counter(reset_mark(undo)))
    keymap_emacs["LC-Slash"]  = reset_search(reset_counter(reset_mark(undo)))
    keymap_emacs["LC-x"]["u"] = reset_search(reset_counter(reset_mark(undo)))

    # LC-Underscore を機能させるための設定
    if is_japanese_keybord:
        keymap_emacs["LC-S-BackSlash"] = reset_search(reset_undo(reset_counter(reset_mark(undo))))
    else:
        keymap_emacs["LC-S-Minus"]     = reset_search(reset_undo(reset_counter(reset_mark(undo))))

    if is_japanese_keybord:
        # LC-Atmark だとうまく動かない方が居るようなので LC-(192) としている
        # （http://bhby39.blogspot.jp/2015/02/windows-emacs.html）
        keymap_emacs["LC-(192)"] = reset_search(reset_undo(reset_counter(set_mark_command)))
    else:
        # LC-S-2 は有効とならないが、一応設定は行っておく（LC-S-3 などは有効となる。なぜだろう？）
        keymap_emacs["LC-S-2"] = reset_search(reset_undo(reset_counter(set_mark_command)))

    keymap_emacs["LC-Space"] = reset_search(reset_undo(reset_counter(set_mark_command)))

    keymap_emacs["LC-x"]["h"]   = reset_search(reset_undo(reset_counter(reset_mark(mark_whole_buffer))))
    keymap_emacs["LC-x"]["C-p"] = reset_search(reset_undo(reset_counter(reset_mark(mark_page))))

    ## 「バッファ / ウインドウ操作」のキー設定
    keymap_emacs["LC-x"]["k"] = reset_search(reset_undo(reset_counter(reset_mark(kill_buffer))))
    keymap_emacs["LC-x"]["b"] = reset_search(reset_undo(reset_counter(reset_mark(switch_to_buffer))))
    keymap_emacs["LC-x"]["o"] = reset_search(reset_undo(reset_counter(reset_mark(other_window))))

    ## 「文字列検索 / 置換」のキー設定
    keymap_emacs["LC-r"] = reset_undo(reset_counter(reset_mark(isearch_backward)))
    keymap_emacs["LC-s"] = reset_undo(reset_counter(reset_mark(isearch_forward)))

    keymap_emacs["LA-S-5"]                = reset_search(reset_undo(reset_counter(reset_mark(query_replace))))
    keymap_emacs["Esc"]["S-5"]            = keymap_emacs["LA-S-5"]
    keymap_emacs["LC-OpenBracket"]["S-5"] = keymap_emacs["LA-S-5"]

    ## 「キーボードマクロ」のキー設定
    if is_japanese_keybord:
        keymap_emacs["LC-x"]["S-8"] = kmacro_start_macro
        keymap_emacs["LC-x"]["S-9"] = kmacro_end_macro
    else:
        keymap_emacs["LC-x"]["S-9"] = kmacro_start_macro
        keymap_emacs["LC-x"]["S-0"] = kmacro_end_macro

    keymap_emacs["LC-x"]["e"] = reset_search(reset_undo(reset_counter(repeat(kmacro_end_and_call_macro))))

    ## 「その他」のキー設定
    keymap_emacs["Enter"]       = reset_undo(reset_counter(reset_mark(repeat(newline))))
    keymap_emacs["LC-m"]        = keymap_emacs["Enter"]
    keymap_emacs["LC-j"]        = reset_undo(reset_counter(reset_mark(newline_and_indent)))
    keymap_emacs["Tab"]         = reset_undo(reset_counter(reset_mark(repeat(indent_for_tab_command))))
    keymap_emacs["LC-i"]        = keymap_emacs["Tab"]
    keymap_emacs["LC-g"]        = reset_search(reset_counter(reset_mark(keybord_quit)))
    keymap_emacs["LC-x"]["C-c"] = reset_search(reset_undo(reset_counter(reset_mark(kill_emacs))))

    keymap_emacs["LA-S-1"]                = reset_search(reset_undo(reset_counter(reset_mark(shell_command))))
    keymap_emacs["Esc"]["S-1"]            = keymap_emacs["LA-S-1"]
    keymap_emacs["LC-OpenBracket"]["S-1"] = keymap_emacs["LA-S-1"]


    ####################################################################################################
    ## リストウィンドウ用の設定
    ####################################################################################################

    keymap_lw = keymap.defineWindowKeymap(class_name="keyhacWindowClass")

    # リストウィンドウで検索が開始されると True になる
    keymap_lw.is_searching = False

    ##################################################
    ## 文字列検索 / 置換（リストウィンドウ用）
    ##################################################

    def lw_isearch(direction):
        if keymap_lw.is_searching:
            keymap.command_InputKey({"backward":"Up", "forward":"Down"}[direction])()
        else:
            keymap.command_InputKey("f")()
            keymap_lw.is_searching = True

    def lw_isearch_backward():
        lw_isearch("backward")

    def lw_isearch_forward():
        lw_isearch("forward")

    ##################################################
    ## その他（リストウィンドウ用）
    ##################################################

    def lw_keybord_quit():
        keymap.command_InputKey("Esc")()

    def lw_clipboardList():
        keymap.command_ClipboardList()

    ##################################################
    ## 共通関数（リストウィンドウ用）
    ##################################################

    def lw_reset_search(func):
        def _func():
            func()
            keymap_lw.is_searching = False
        return _func

    ##################################################
    ## キーバインド（リストウィンドウ用）
    ##################################################

    ## 「カーソル移動」のキー設定
    keymap_lw["LC-b"] = backward_char
    keymap_lw["LC-f"] = forward_char

    keymap_lw["LC-p"] = previous_line
    keymap_lw["LC-n"] = next_line

    keymap_lw["LA-v"] = scroll_up
    keymap_lw["LC-v"] = scroll_down

    ## 「カット / コピー / 削除 / アンドゥ」のキー設定
    keymap_lw["LC-h"] = delete_backward_char
    keymap_lw["LC-d"] = delete_char

    ## 「文字列検索 / 置換」のキー設定
    keymap_lw["LC-r"] = lw_isearch_backward
    keymap_lw["LC-s"] = lw_isearch_forward

    ## 「その他」のキー設定
    keymap_lw["Enter"] = lw_reset_search(newline)
    keymap_lw["LC-m"]  = keymap_lw["Enter"]
    keymap_lw["LC-g"]  = lw_reset_search(lw_keybord_quit)

    # リストウィンドウで検索中に以下の3つのキーを押された時、lw_reset_search を実行する
    keymap_lw["LS-Enter"] = lw_reset_search(self_insert_command("S-Enter"))
    keymap_lw["LC-Enter"] = lw_reset_search(self_insert_command("C-Enter"))
    keymap_lw["LA-Enter"] = lw_reset_search(self_insert_command("A-Enter"))

    # リストウィンドウを LA-y で閉じるために必要な設定
    keymap_lw["LA-y"] = lw_reset_search(lw_clipboardList)

    # クリップボードリストを起動する
    keymap_emacs["LC-x"]["C-y"] = lw_reset_search(reset_search(reset_undo(reset_counter(reset_mark(lw_clipboardList)))))

    keymap_emacs["LA-y"]                = lw_reset_search(reset_search(reset_undo(reset_counter(reset_mark(lw_clipboardList)))))
    keymap_emacs["Esc"]["y"]            = keymap_emacs["LA-y"]
    keymap_emacs["LC-OpenBracket"]["y"] = keymap_emacs["LA-y"]


    ####################################################################################################
    ## クリップボードリストを拡張する
    ####################################################################################################
    if 1:
        # クリップボードリストを拡張するための設定です。クリップボードリストは LC-x C-y や
        # LA-y で起動します。クリップボードリストを開いた後、LC-f（→）や LC-b（←）キーを
        # 入力することで画面を切り替えることができます。
        # （参考：https://github.com/crftwr/keyhac/blob/master/_config.py）

        # リストウィンドウの幅を定義する
        list_window_width = 30

        # 定型文
        fixed_items = [
            ("メールアドレス", "user_name@domain_name"),
            ("住所",           "〒999-9999 ＮＮＮＮＮＮＮＮＮＮ"),
            ("電話番号",       "99-999-9999"),
            (" " * list_window_width, None),
        ]

        import datetime

        # 日時をペーストする機能
        def dateAndTime(fmt):
            def _func():
                return datetime.datetime.now().strftime(fmt)
            return _func

        # 日時
        datetime_items = [
            ("YYYY/MM/DD HH:MM:SS", dateAndTime("%Y/%m/%d %H:%M:%S")),
            ("YYYY/MM/DD",          dateAndTime("%Y/%m/%d")),
            ("HH:MM:SS",            dateAndTime("%H:%M:%S")),
            ("YYYYMMDD_HHMMSS",     dateAndTime("%Y%m%d_%H%M%S")),
            ("YYYYMMDD",            dateAndTime("%Y%m%d")),
            ("HHMMSS",              dateAndTime("%H%M%S")),
            (" " * list_window_width, None),
        ]

        keymap.cblisters += [
            ("定型文",  cblister_FixedPhrase(fixed_items)),
            ("日時",    cblister_FixedPhrase(datetime_items)),
        ]


    ####################################################################################################
    ## クリップボードリストの機能を emacs キーバインドを適用していないアプリケーションソフトでも利用する
    ####################################################################################################
    if 1:
        # emacs キーバインドを適用していないアプリケーションソフトでもクリップボードリストの機能
        # を利用するための設定です。この設定では、クリップボードリストでの Enter（テキストの貼り
        # 付け）を S-Enter（クリップボードへの格納）に置き換えています。（emacs キーバインドを
        # 適用していないアプリケーションソフトでは、キーの入出力の方式が特殊なものが多いと思われる
        # ため。）このため、アプリケーションソフトにペーストする場合は、そのアプリケーションソフト
        # のペースト操作で行ってください。
        # （この対応で、コマンドプロンプトなどのアプリケーションソフトでも、クリップボードリスト
        # 　の利用を可能としています。もし、どうしても Enter（テキストの貼り付け）の入力を行い
        # 　たい場合には、C-m で対応してください。なお、C-Enter（引用記号付で貼り付け）の置き換え
        # 　は、対応が複雑となるため行っていません。）

        def lw_newline():
            if keymap.window_keybind == "emacs":
                keymap.command_InputKey("Enter")()
            else:
                keymap.command_InputKey("S-Enter")()

        keymap_lw["Enter"] = lw_reset_search(lw_newline)

        keymap_not_emacs = keymap.defineWindowKeymap(check_func=lambda window: not is_emacs_target(window))

        # クリップボードリストを起動する
        keymap_not_emacs["LA-y"] = lw_reset_search(lw_clipboardList)


    ####################################################################################################
    ## ランチャー用のリストを作成する
    ####################################################################################################
    if 1:
        # クリップボードリストとは別にランチャー用のリストを利用するための設定です。このリストは、
        # 全てのアプリケーションソフトで LA-l のキーを押すことにより起動します。
        # （NTEmacs など全てのアプリケーションソフトのキーに対し有効となっています。キーの変更を
        # 　したい場合は最終行の設定を調整してください。RA-l にする方法もあるかと思います。）
        # （参考：https://github.com/crftwr/keyhac/blob/master/_config.py）

        def lw_lancherList():
            def popLancherList():

                # リストウィンドウの幅を定義する
                list_window_width = 30

                # すでにリストが開いていたら閉じるだけ
                if keymap.isListWindowOpened():
                    keymap.cancelListWindow()
                    return

                # ウィンドウ
                window_items = []

                def popWindow(wnd):
                    def _func():
                        if wnd.isMinimized():
                            wnd.restore()
                        wnd.getLastActivePopup().setForeground()
                    return _func

                def pushWindowItems(wnd, arg):
                    # ランチャーリストに載せたくないアプリケーションソフトは、re.match の正規表現に
                    # 「|」を使って繋げて指定してください。
                    if wnd.isVisible() and not wnd.getOwner() and (wnd.getClassName() == "Emacs" or wnd.getText() != "") and \
                       not re.match(r"^Progman$", wnd.getClassName()) and \
                       not re.match(r"^RocketDock.exe$", wnd.getProcessName()):
                        # 確認用デバッグライト（アンコメント化すると、情報がコンソールウインドウに表示されます。）
                        # print(wnd.getProcessName() + " : " + wnd.getClassName() + " : " + wnd.getText())
                        window_items.append((wnd.getProcessName() + " : " + wnd.getText(), popWindow(wnd)))
                    return True

                Window.enum(pushWindowItems, None)
                window_items.append(("<Desktop>", keymap.command_ShellExecute(None, r"shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}", "", "")))
                window_items.append((" " * list_window_width, None))

                # アプリケーションソフト
                application_items = [
                    ("notepad",  keymap.command_ShellExecute(None, r"notepad.exe", "", "")),
                    ("sakura",   keymap.command_ShellExecute(None, r"C:\Program Files (x86)\sakura\sakura.exe", "", "")),
                    ("explorer", keymap.command_ShellExecute(None, r"explorer.exe", "", "")),
                    ("cmd",      keymap.command_ShellExecute(None, r"cmd.exe", "", "")),
                    ("chrome",   keymap.command_ShellExecute(None, r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "", "")),
                    ("firefox",  keymap.command_ShellExecute(None, r"C:\Program Files (x86)\Mozilla Firefox\firefox.exe", "", "")),
                    (" " * list_window_width, None),
                ]

                # ウェブサイト
                website_items = [
                    ("Google",         keymap.command_ShellExecute(None, r"https://www.google.co.jp/", "", "")),
                    ("Facebook",       keymap.command_ShellExecute(None, r"https://www.facebook.com/", "", "")),
                    ("Twitter",        keymap.command_ShellExecute(None, r"https://twitter.com/", "", "")),
                    ("keyhac",         keymap.command_ShellExecute(None, r"https://sites.google.com/site/craftware/keyhac", "", "")),
                    ("NTEmacs ウィキ", keymap.command_ShellExecute(None, r"http://www49.atwiki.jp/ntemacs/", "", "")),
                    (" " * list_window_width, None),
                ]

                # その他
                other_items = [
                    ("Edit   config.py", keymap.command_EditConfig),
                    ("Reload config.py", keymap.command_ReloadConfig),
                    (" " * list_window_width, None),
                ]

                listers = [
                    ("Window",  cblister_FixedPhrase(window_items)),
                    ("App",     cblister_FixedPhrase(application_items)),
                    ("Website", cblister_FixedPhrase(website_items)),
                    ("Other",   cblister_FixedPhrase(other_items)),
                ]

                select_item = keymap.popListWindow(listers)

                if not select_item:
                    Window.find("Progman", None).setForeground()
                    select_item = keymap.popListWindow(listers)

                if select_item and select_item[0] and select_item[0][1]:
                    select_item[0][1]()

            # キーフックの中で時間のかかる処理を実行できないので、delayedCall() をつかって遅延実行する
            keymap.delayedCall(popLancherList, 0)

        keymap_global = keymap.defineWindowKeymap()

        # ランチャー用リストを起動する
        keymap_global["LA-l"] = lw_reset_search(lw_lancherList)


    ####################################################################################################
    ## Excel の場合、^Enter に F2（セル編集モード移行）を割り当てる（オプション）
    ####################################################################################################
    if 1:
        keymap_excel = keymap.defineWindowKeymap(class_name="EXCEL*")

        # C-Enter 押下で、「セル編集モード」に移行する
        keymap_excel["LC-Enter"] = reset_search(reset_undo(reset_counter(reset_mark(self_insert_command("F2")))))


    ####################################################################################################
    ## Emacs の場合、IME 切り替え用のキーを C-\ に置き換える（オプション）
    ####################################################################################################
    if 0:
        # NTEmacs の利用時に Windows の IME の切換えを無効とするための設定です。（mozc.el を利用する場合など）
        # 追加したいキーがある場合は、次の方法で追加するキーの名称もしくはコードを確認し、
        # スクリプトを修正してください。
        # 　1) タスクバーにある keyhac のアイコンを左クリックしてコンソールを開く。
        # 　2) アイコンを右クリックしてメニューを開き、「内部ログ ON」を選択する。
        # 　3) 確認したいキーを押す。 

        keymap_real_emacs = keymap.defineWindowKeymap(class_name="Emacs")

        # IME 切り替え用のキーを C-\ に置き換える
        keymap_real_emacs["(28)"]   = self_insert_command("C-Yen") # 「変換」キー
        keymap_real_emacs["(29)"]   = self_insert_command("C-Yen") # 「無変換」キー
        keymap_real_emacs["(240)"]  = self_insert_command("C-Yen") # 「英数」キー
        keymap_real_emacs["(242)"]  = self_insert_command("C-Yen") # 「カタカナ・ひらがな」キー
        keymap_real_emacs["(243)"]  = self_insert_command("C-Yen") # 「半角／全角」キー
        keymap_real_emacs["(244)"]  = self_insert_command("C-Yen") # 「半角／全角」キー
        keymap_real_emacs["A-(25)"] = self_insert_command("C-Yen") # 「Alt-`」 キー