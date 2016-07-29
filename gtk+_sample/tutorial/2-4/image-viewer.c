//----------------------------------------------------------------------
/**
   @file image-viewer.c
   @brief イメージビューワー
   
   @author Shibata
   @date 2015-06-09(火) 22:45:01
   
***********************************************************************/

#include <gtk/gtk.h>


/*
 ボタンがクリックされた時に呼び出される関数
*/
static void
cb_button_clicked (GtkWidget *button, gpointer user_data)
{
  /* メインループ終了 */
  gtk_main_quit ();
}

/*
  メイン関数
*/
int main (int argc, char** argv)
{
  GtkWidget *window;

  /* 引数のチェック */
  if (argc != 2)
    {
      g_print ("Usage: %s image-file\n", argv[0]);
      exit (1);
    }
  /* GTK+の初期化およびオプション解析 */
  gtk_init (&argc, &argv);
  /* ウィンドウの作成 */
  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  /* ウィンドウの大きさの設定 */
  gtk_widget_set_size_request (window, 300, 200);
  {
    GtkWidget *vbox;

    /* 縦にウィジェットを配置するボックスの作成 */
    vbox = gtk_vbox_new (FALSE, 2);
    /* ボックスをウィンドウに配置 */
    gtk_container_add (GTK_CONTAINER (window), vbox);
    {
      GtkWidget *scroll_window;
      GtkWidget *button;

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
	
	/* ファイルから読み込んでイメージの作成 */
	image = gtk_image_new_from_file (argv[1]);
	/* イメージをスクロールバーウィンドウに配置 */
	gtk_scrolled_window_add_with_viewport (GTK_SCROLLED_WINDOW(scroll_window),
					       image);
      }

      /* ボタンの作成 */
      button = gtk_button_new_with_label ("Quit");
      /* ボタンをボックスに配置 */
      gtk_box_pack_start (GTK_BOX (vbox), button, FALSE, FALSE, 0);
      /* ボタンがクリックされた時に呼び出される関数の設定 */
      g_signal_connect (G_OBJECT (button), "clicked",
			G_CALLBACK(cb_button_clicked), NULL);
    }
  }
  /* ウィンドウの表示 */
  gtk_widget_show_all (window);
  /* メインループ */
  gtk_main ();

  return 0;
}


