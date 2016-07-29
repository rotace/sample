//----------------------------------------------------------------------
/**
   @file image-viewer.c
   @brief イメージビューワー
   
   @author Shibata
   @date 2015-06-09(火) 22:45:01
   
***********************************************************************/

#include <gtk/gtk.h>

/*
  Openメニューが選択された時に呼び出される関数
*/
static void
cb_open ( GtkAction *action, gpointer user_data)
{
  GtkWidget* window;
  GtkWidget* dialog;
  gint response;

  /* ウィンドウの取得 */
  window = GTK_WIDGET (user_data);
  /* ファイル選択ダイアログの作成 */
  dialog = gtk_file_chooser_dialog_new ( "Open an image",
					 GTK_WINDOW (window),
					 GTK_FILE_CHOOSER_ACTION_OPEN,
					 GTK_STOCK_CANCEL,
					 GTK_RESPONSE_CANCEL,
					 GTK_STOCK_OPEN,
					 GTK_RESPONSE_ACCEPT,
					 NULL);
  /* ダイアログの表示 */
  gtk_widget_show_all (dialog);
  /* ダイアログによるファイル選択処理 */
  response = gtk_dialog_run (GTK_DIALOG (dialog));
  if (response == GTK_RESPONSE_ACCEPT)
    {
      gchar *filename;
      GtkWidget *image;

      /* 選択したファイル名の取得 */
      filename = gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (dialog));
      /* イメージの取得 */
      image = GTK_WIDGET (g_object_get_data (G_OBJECT (window), "image"));
      /* ファイルから画像を読み込んでイメージにセット */
      gtk_image_set_from_file (GTK_IMAGE (image), filename);
      /* 文字列領域の解放 */
      g_free (filename);
    }
  /* ダイアログの破棄 */
  gtk_widget_destroy (dialog);
}

/*
  Quitメニューが選択された時に呼び出される関数
*/
static void
cb_quit ( GtkAction *action, gpointer user_data)
{
  GObject *window = G_OBJECT (user_data);

  g_object_unref (g_object_get_data (window, "ui"));
  gtk_main_quit();
}
/*
  メニューアイテムの構造
*/
static const gchar *menu_info =
  "<ui>"
  "  <menubar name='Menubar'>"
  "    <menu name='File' action='File'>"
  "      <menuitem name='Open' action='Open'/>"
  "      <separator/>"
  "      <menuitem name='Quit' action='Quit'/>"
  "    </menu>"
  "  </menubar>"
  "</ui>";

/*
 メニューアイテムの詳細
*/
static GtkActionEntry entries[] = {
  {"File", NULL, "_File"},
  {"Open", GTK_STOCK_OPEN, "_Open", "<control>O", "Open an image",
   G_CALLBACK (cb_open)},
  {"Quit", GTK_STOCK_QUIT, "_Quit", "<control>Q", "Quit this program",
   G_CALLBACK (cb_quit)}
};

/*
 メニュー作成関数
*/
static GtkUIManager* create_menu (GtkWidget *parent)
{
  GtkUIManager *ui;
  GtkActionGroup *actions;

  /* UIマネージャーの作成 */
  ui = gtk_ui_manager_new ();
  /* アクショングループの作成 */
  actions = gtk_action_group_new ("menu");
  /* アクショングループにメニューアイテムを追加 */
  gtk_action_group_add_actions (actions, entries ,
				sizeof (entries) / sizeof (entries[0]),
				parent);
  /* UIマネージャーにアクショングループを追加 */
  gtk_ui_manager_insert_action_group(ui, actions, 0);
  /* UIマネージャーにメニュー構成を追加 */
  gtk_ui_manager_add_ui_from_string (ui, menu_info, -1, NULL);
  /* メニューアイテムに定義されたショートカットをウィンドウ上でも有効にする設定 */
  gtk_window_add_accel_group (GTK_WINDOW (parent),
			      gtk_ui_manager_get_accel_group (ui));
  return ui;
}


/*
  メイン関数
*/
int main (int argc, char** argv)
{
  GtkWidget *window;

  /* GTK+の初期化およびオプション解析 */
  gtk_init (&argc, &argv);
  /* ウィンドウの作成 */
  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  /* ウィンドウの大きさの設定 */
  gtk_widget_set_size_request (window, 400, 300);
  {
    GtkWidget *vbox;
    
    /* 縦にウィジェットを配置するボックスの作成 */
    vbox = gtk_vbox_new (FALSE, 2);
    /* ボックスをウィンドウに配置 */
    gtk_container_add (GTK_CONTAINER (window), vbox);
    {
      GtkUIManager *ui;
      GtkWidget *menubar;
      GtkWidget *scroll_window;

      /* メニューの作成 */
      ui = create_menu (window);
      /* ウィンドウにUIマネージャーをデータとしてセット */
      g_object_set_data (G_OBJECT (window), "ui", (gpointer) ui);
      /* メニューバーを取得 */
      menubar = gtk_ui_manager_get_widget (ui, "/Menubar");
      /* メニューをボックスに配置 */
      gtk_box_pack_start (GTK_BOX (vbox), menubar, FALSE, FALSE, 0);
      /* スクロールバー付きウィンドウの作成 */
      scroll_window = gtk_scrolled_window_new (NULL, NULL);
      /* スクロールバー付きウィンドウをボックスに配置 */
      gtk_box_pack_start(GTK_BOX (vbox), scroll_window, TRUE, TRUE, 0);
      /* スクロールバーの表示設定 */
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW(scroll_window),
				      GTK_POLICY_AUTOMATIC,
				      GTK_POLICY_AUTOMATIC);
      {
	GtkWidget *image;
	
	/* イメージの作成 */
	image = gtk_image_new ();
	/* イメージをスクロールバーウィンドウに配置 */
	gtk_scrolled_window_add_with_viewport (GTK_SCROLLED_WINDOW(scroll_window),
					       image);
	/* ウィンドウにイメージをデータとしてセット */
	g_object_set_data (G_OBJECT (window), "image", (gpointer) image);
      }
    }
  }
  /* ウィンドウの表示 */
  gtk_widget_show_all (window);
  /* メインループ */
  gtk_main ();

  return 0;
}


