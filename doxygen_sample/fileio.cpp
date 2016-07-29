/** 
 * @file  fileio.cpp
 * @brief ファイル入出力 (実装)
 *
 * @author Oka (LangEdge, Inc.)
 * @date 2001-05-17
 * @version $Id: fileio.cpp,v 1.1 2001/06/11 02:25:31 oka Exp $
 *
 * Copyright (C) 2001 LangEdge, Inc. All rights reserved.
 */
#include "lei_fileutil.h"
#include "lei_memutil.h"
#include <string.h>

using namespace std;

namespace LEIUtil {

/*----------------------------------------------------------------------
  ファイル入出力
----------------------------------------------------------------------*/
/** ファイルのオープン
 * @param filename オープンするファイルのパス名 (C-string)
 * @param mode オープンモード。 enum OpenMode の要素のビット和。
 * @retval 0 正常終了
 * @retval -1 ファイルをオープンできなかった
 */
int FileIO::open( const char *filename, int mode ) {
    string strMode;
    if ( (mode & APPEND) != 0 ) {
        strMode = "a";
    } else if ( (mode & UPDATE) != 0 ) {
        strMode = "r+";
    } else if ( (mode & WRITE) != 0 ) {
        strMode = "w";
    } else {
        strMode = "r";
    }

    if ( (mode & TEXT) == 0 ) {
        strMode += "b";
    }

    _filePtr = fopen( filename, strMode.c_str() );
    if ( _filePtr != NULL )
        return 0;
    return -1;
}

/** ファイルのオープン (読み込み用)
 * @param filename オープンするファイルのパス (C-string)
 * @retval 0 正常終了
 * @retval -1 ファイルをオープンできなかった
 */
int FileIO::open( const char *filename )
{
    return FileIO::open( filename, READ );
}

/** ファイルのクローズ
 */
void FileIO::close()
{
    if ( _filePtr ) {
        fclose( _filePtr );
    }
    _filePtr = NULL;
}


/** ブロック入力
 * @param block 読み込んだデータの格納先
 * @param size block の大きさ
 * @return 読み込んだデータのバイトサイズ (0 なら EOF)
 * @exception FileReadError 読み込み時にエラーが発生した
 */
int FileIO::read( void *block, size_t size ) throw( FileReadError )
{
    int num = fread( block, 1, size, _filePtr );
    if (num < 0)
        throw FileReadError();
    return num;
}

/** ブロック出力
 * @param block 書き出すデータブロック位置
 * @param size block の大きさ
 * @return 書き出しだデータのバイトサイズ
 * @exception FileWriteError 書き出し時にエラーが発生した
 */
int FileIO::write( const void *block, size_t size ) throw( FileWriteError )
{
    int num = fwrite( block, 1, size, _filePtr);
    if (num < (int)size)
        throw FileWriteError();
    return num;
}

/** ファイルアクセス位置の取得
 * @return 次のファイルアクセスが行われる位置を、
 *         ファイルの先頭からバイトオフセットで返す
 * @exception FileIOError 処理中にエラーが発生した
 */
size_t FileIO::getFilePosition() throw( FileIOError )
{
    int pos = ftell( _filePtr );
    if (pos < 0)
        throw FileIOError();

    return pos;
}

/** ファイルアクセス位置の設定.
 * @param pos 次のファイルアクセスが行われる位置を、
 *            ファイルの先頭からバイトオフセットで指定する
 * @exception FileIOError 処理中にエラーが発生した
 */
void FileIO::setFilePosition( size_t pos ) throw( FileIOError )
{
    int ret = fseek( _filePtr, (long)pos, SEEK_SET );

    if (ret != 0)
        throw FileIOError();
}

/** ファイルのインポート.
 * 指定されたファイルの内容を、現在のファイルアクセス位置に取り込む
 * @param filename 読み込むファイル名
 */
void FileIO::importFile( const char *filename )
{
    FileInput inFile( filename );

    const size_t BUFFER_SIZE = 0x100000;
    CAutoBuf buf( BUFFER_SIZE );

    while (1) {
        size_t siz = inFile.read( buf.getPtr(), BUFFER_SIZE );
        if (siz == 0) break;
        write( buf.getPtr(), siz );
    }
}

/*----------------------------------------------------------------------
  ファイル入力
----------------------------------------------------------------------*/
/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (C-string)
 * @exception FileOpenError ファイルのオープンに失敗した
 */
FileInput::FileInput( const char *filename ) throw( FileOpenError )
{
    if ( open( filename ) < 0 )
        throw FileOpenError();
}

/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (std::string)
 * @exception FileOpenError ファイルのオープンに失敗した
 */
FileInput::FileInput( const std::string& filename ) throw( FileOpenError ) {
    if ( open( filename ) < 0 )
        throw FileOpenError();
}

/** 一行入力 (C string)
 *
 * 改行文字を含む、一行入力。入力文字列の末尾には null が付加される
 *
 * @param buf 入力した一行を格納するバッファ
 * @param size バッファの大きさ
 * @retval 0 EOF
 * @retval >0 一行の長さ (改行文字含む)
 */
size_t FileInput::getline( char *buf, size_t size ) {
    buf[0] = '\0';
    if ( _filePtr == NULL )
        return 0;

    if ( fgets(buf, size, _filePtr) == NULL )
        return 0;

    return strlen( buf );
}

/** 一行入力 (C string)
 *
 * 改行文字を含む、一行入力。
 *
 * @param str 入力した一行を格納する文字列
 * @retval 0 EOF
 * @retval >0 一行の長さ (改行文字含む)
 */
size_t FileInput::getline( string& str ) {
    char buf[32000];
    size_t len = getline( buf, 32000 );
    str = buf;
    return len;
}


/*----------------------------------------------------------------------
  ファイル出力
----------------------------------------------------------------------*/
/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (C-string)
 * @exception FileOpenError ファイルのオープンあるいは作成に失敗した
 */
FileOutput::FileOutput( const char *filename ) throw( FileOpenError ) {
    if (open( filename ) < 0)
        throw FileOpenError();
}

/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (std::string)
 * @exception FileOpenError ファイルのオープンあるいは作成に失敗した
 */
FileOutput::FileOutput( const std::string& filename ) throw( FileOpenError ) {
    if (open( filename ) < 0)
        throw FileOpenError();
}

/** ファイルのオープン (書き込み用)
 * @param filename オープンするファイルのパス名
 * @retval 0 正常終了
 * @retval <0 ファイルのオープンあるいは作成に失敗した
 */
int FileOutput::open( const char *filename ) {
    return FileIO::open( filename, WRITE );
}

/** 一行出力
 * @param str 出力する文字列
 */
void FileOutput::print( const char *str ) {
    if (_filePtr != NULL)
        fputs( str, _filePtr );
}

/** フォーマット付き一行出力
 * @param fmt 出力する文字列のフォーマット
 */
void FileOutput::printf( const char *fmt, ... ) {
    va_list arg_ptr;
    va_start(arg_ptr, fmt);

    if (_filePtr != NULL)
      vfprintf(_filePtr, fmt, arg_ptr);

    va_end(arg_ptr);
}

/*----------------------------------------------------------------------
  テキストファイル出力
----------------------------------------------------------------------*/
/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (C-string)
 * @exception FileOpenError ファイルのオープンあるいは作成に失敗した
 */
TextFileOutput::TextFileOutput( const char *filename ) throw( FileOpenError ) {
    if (open( filename ) < 0)
        throw FileOpenError();
}

/** コンストラクタ (ファイルオープン)
 * @param filename オープンするファイルのパス (std::string)
 * @exception FileOpenError ファイルのオープンあるいは作成に失敗した
 */
TextFileOutput::TextFileOutput( const std::string& filename ) throw( FileOpenError ) {
    if (open( filename ) < 0)
        throw FileOpenError();
}

/** テキストファイルのオープン (書き込み用)
 * @param filename オープンするファイルのパス名
 * @retval 0 正常終了
 * @retval <0 ファイルのオープンあるいは作成に失敗した
 */
int TextFileOutput::open( const char *filename ) {
    return FileIO::open( filename, WRITE | TEXT );
}


} // end of namespace


