/** 
 * @file  lei_fileutil.h
 * @brief ファイル入出力関係のユーティリティ
 *
 * @author Oka (LangEdge, Inc.)
 * @date 2001-05-17
 * @version $Id: lei_fileutil.h,v 1.1 2001/06/11 02:25:31 oka Exp $
 *
 * Copyright (C) 2001 LangEdge, Inc. All rights reserved.
 */

/** \mainpage
 *
 * これは、
 * fopen/fclose/fread/fwrite/fgets/fputs/fprintf/ftell/fseek など、
 * C標準ライブラリの入出力関数を使ってファイルアクセスをするための
 * ラッパークラスを提供するクラスライブラリです。
 *
 * クラス一覧:
 * - LEIUtil::FileIO : ブロック指向の入出力のみをサポート
 * - LEIUtil::FileInput : FileIO から派生したクラスで、行指向の入力もサポート
 * - LEIUtil::FileOutput : FileIO から派生したクラスで、行指向の出力もサポート
 * - LEIUtil::TextFileOutput : FileOutput から派生したクラスで、テキストファイル出力をサポート
 *
 * ファイル操作関数一覧:
 * - void LEIUtil::removeFile( const char* ) : ファイル削除 (C-string なファイル名)
 * - void LEIUtil::removeFile( const std::string& ) : ファイル削除 (std::string なファイル名)
 */

#ifndef LEI_FILE_UTIL_H
#define LEI_FILE_UTIL_H

#include <stdio.h>
#include <string>

#define  LangEdgeUtil  LEIUtil
namespace LEIUtil {

/*----------------------------------------------------------------------
  例外
----------------------------------------------------------------------*/
class FileIOError { };
class FileOpenError : public FileIOError { };
class FileReadError : public FileIOError { };
class FileWriteError : public FileIOError { };

/*----------------------------------------------------------------------
  ファイル入出力
----------------------------------------------------------------------*/
/** ファイル入出力のラッパークラス
 *
 * fopen/fclose/fread/fwrite/fgets/fputs/fprintf/ftell/fseek など、
 * C標準ライブラリの入出力関数を使ってファイルアクセスをするための
 * ラッパークラス。<br>
 * FileIO は、ブロック指向の入出力のみをサポートする。行指向の入出力は、
 * FileIO から派生した FileInput や FileOutput でサポートされる。
 */
class FileIO {
public:
    /// オープンモード
    enum OpenMode {
        READ      = 0,
        WRITE     = 1,
        UPDATE    = 2,
        APPEND    = 4,
        TEXT      = 8,
    };

public:
    /// デフォルトコンストラクタ
    FileIO() : _filePtr( NULL ) { }

    /// デストラクタ (ファイルクローズも行う)
    virtual ~FileIO() {
        close();
    }

    /// ファイルのオープン -- 読み込み用 (C string なファイル名)
    virtual int open( const char *filename );

    /// ファイルのオープン -- 読み込み用 (std::string なファイル名)
    virtual inline int open( const std::string& filename ) {
        return open( filename.c_str() );
    }

    /// ファイルのオープン -- モード付き (C string なファイル名)
    virtual int open( const char *filename, int mode );

    /// ファイルのオープン -- モード付き (std::string なファイル名)
    inline int open( const std::string& filename, int mode ) {
        return open( filename.c_str(), mode );
    }

    /// ファイルのクローズ
    void close();

    /// ブロック入力
    int read( void *block, size_t size ) throw( FileReadError );

    /// ブロック出力
    int write( const void *block, size_t size ) throw( FileWriteError );

    /// ファイルアクセス位置の取得
    size_t getFilePosition() throw( FileIOError );

    /// ファイルアクセス位置の設定
    void setFilePosition( size_t pos ) throw( FileIOError );

    /// ファイルのインポート (C-string なファイル名)
    void importFile( const char *filename );

    /// ファイルのインポート (std::string なファイル名)
    void importFile( const std::string& filename ) {
        importFile( filename.c_str() );
    }

protected:
    FILE *_filePtr;
};


/*----------------------------------------------------------------------
  ファイル入力
----------------------------------------------------------------------*/
/** ファイル入力
 *
 * ファイルの入力に特化したラッパークラス。FileIO から派生する。<br>
 * 行指向の入力メソッドをサポートする。
 */
class FileInput : public FileIO {
public:
    /// デフォルトコンストラクタ
    FileInput() { }

    /// コンストラクタ (C-string なファイル名によるファイルオープン)
    FileInput( const char *filename ) throw( FileOpenError );

    /// コンストラクタ (std::string なファイル名によるファイルオープン)
    FileInput( const std::string& filename ) throw( FileOpenError );

    /// デストラクタ (ファイルクローズも行う)
    virtual ~FileInput() { }

    /// 一行入力 (C-string なバッファ)
    size_t getline( char *buf, size_t size );

    /// 一行入力 (std::string なバッファ)
    size_t getline( std::string& str );
};


/*----------------------------------------------------------------------
  ファイル出力
----------------------------------------------------------------------*/
/** ファイル出力
 *
 * ファイルの出力に特化したラッパークラス。FileIO から派生する。<br>
 * 行指向の出力メソッドをサポートする。とくに、fprintf を使用する、
 * フォーマット付き出力もサポートされる。
 */
class FileOutput : public FileIO {
public:
    /// デフォルトコンストラクタ
    FileOutput() { }

    /// コンストラクタ (C-string なファイル名によるファイルオープン)
    FileOutput( const char *filename ) throw( FileOpenError );

    /// コンストラクタ (std::string なファイル名によるファイルオープン)
    FileOutput( const std::string& filename ) throw( FileOpenError );

    /// デストラクタ (ファイルクローズも行う)
    virtual ~FileOutput() { }

    /// ファイルのオープン -- 書き込み用 (C-string なファイル名)
    virtual int open( const char *filename );

    /// ファイルのオープン -- 書き込み用 (std::string なファイル名)
    inline int open( const std::string& filename ) {
        return open( filename.c_str() );
    }

    /// 一行出力 (C-string)
    void print( const char *str );

    /// 一行出力 (std::string)
    inline void print( const std::string& str ) {
        print( str.c_str() );
    }

    /// フォーマット付き一行出力 (C-string)
    void printf( const char *fmt, ... );
};


/*----------------------------------------------------------------------
  テキストファイル出力
----------------------------------------------------------------------*/
/** テキストファイル出力
 *
 * テキストファイルの出力に特化したラッパークラス。FileOutput から派生し、
 * オープンモードは、TEXT に固定である。<br>
 */
class TextFileOutput : public FileOutput {
public:
    /// デフォルトコンストラクタ
    TextFileOutput() { }

    /// コンストラクタ (C-string なファイル名によるファイルオープン)
    TextFileOutput( const char *filename ) throw( FileOpenError );

    /// コンストラクタ (std::string なファイル名よるファイルオープン)
    TextFileOutput( const std::string& filename ) throw( FileOpenError );

    /// デストラクタ (ファイルクローズも行う)
    virtual ~TextFileOutput() { }

    /// テキストファイルのオープン -- 書き込み用 (C-string なファイル名)
    virtual int open( const char *filename );

    /// ファイルのオープン -- 書き込み用 (std::string なファイル名)
    inline int open( const std::string& filename ) {
        return open( filename.c_str() );
    }
};


/*----------------------------------------------------------------------
  ファイル操作
----------------------------------------------------------------------*/
/// ファイル削除 (C-string なファイル名)
inline void removeFile( const char *filename ) {
    remove( filename );
}

/// ファイル削除 (std::string なファイル名)
inline void removeFile( const std::string& filename ) {
    remove( filename.c_str() );
}

} // end of namespace

#endif // LEI_FILE_UTIL_H

