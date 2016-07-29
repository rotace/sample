#include <iostream>
#include "CppUTest/CommandLineTestRunner.h"
#include "geom.h"
 
// テストグループの定義 TEST_GROUP(group)
// フィクスチャの準備
TEST_GROUP(MatrixTestGroup) {
  geom::AffineMatrix mat;
  const static double eps = __FLT_EPSILON__;
 
  TEST_SETUP() {
    // 各テストケース実行前に呼ばれる、ここではなにもしない
  }
 
  TEST_TEARDOWN() {
    // 各テストケース実行後に呼ばれる、ここではなにもしない
  }
};
 
// テストケース TEST(group, name)
TEST(MatrixTestGroup, TestConstruct) {
  DOUBLES_EQUAL(mat.a, 1.0, eps);
  DOUBLES_EQUAL(mat.b, 0.0, eps);
  DOUBLES_EQUAL(mat.c, 0.0, eps);
  DOUBLES_EQUAL(mat.d, 1.0, eps);
  DOUBLES_EQUAL(mat.tx, 0.0, eps);
  DOUBLES_EQUAL(mat.ty, 0.0, eps);
}
 
TEST(MatrixTestGroup, TestClone) {
  geom::AffineMatrix clone_mat = mat.clone();
  DOUBLES_EQUAL(clone_mat.a, mat.a, eps);
  DOUBLES_EQUAL(clone_mat.b, mat.b, eps);
  DOUBLES_EQUAL(clone_mat.c, mat.c, eps);
  DOUBLES_EQUAL(clone_mat.d, mat.d, eps);
  DOUBLES_EQUAL(clone_mat.tx, mat.tx, eps);
  DOUBLES_EQUAL(clone_mat.ty, mat.ty, eps);
}
 
TEST(MatrixTestGroup, TestConcat) {
  geom::AffineMatrix mat2;
  mat.concat(mat2);
  DOUBLES_EQUAL(mat.a, 1.0, eps);
  DOUBLES_EQUAL(mat.b, 0.0, eps);
  DOUBLES_EQUAL(mat.c, 0.0, eps);
  DOUBLES_EQUAL(mat.d, 1.0, eps);
  DOUBLES_EQUAL(mat.tx, 0.0, eps);
  DOUBLES_EQUAL(mat.ty, 0.0, eps);
}
 
TEST(MatrixTestGroup, TestTranslate) {
  mat.translate(10.0, 20.0);
  DOUBLES_EQUAL(mat.tx, 10.0, eps);
  DOUBLES_EQUAL(mat.ty, 20.0, eps);
}
 
TEST(MatrixTestGroup, TestScale) {
  mat.scale(2.0, 3.0);
  DOUBLES_EQUAL(mat.a, 2.0, eps);
  DOUBLES_EQUAL(mat.b, 3.0, eps);
}
 
TEST(MatrixTestGroup, TestRotate) {
  float radian = M_PI/180*M_PI;
  mat.rotate(M_PI);
  DOUBLES_EQUAL(mat.a, cos(radian), eps);
  DOUBLES_EQUAL(mat.b, sin(radian), eps);
  DOUBLES_EQUAL(mat.c, -sin(radian), eps);
  DOUBLES_EQUAL(mat.d, cos(radian), eps);
}
 
TEST(MatrixTestGroup, TestSkew) {
  mat.skew(10.0, 20.0);
  DOUBLES_EQUAL(mat.b, tan(M_PI/180*20.0), eps);
  DOUBLES_EQUAL(mat.c, tan(M_PI/180*10.0), eps);
}
 
TEST(MatrixTestGroup, TestIdentity) {
  mat.identity();
  DOUBLES_EQUAL(mat.a, 1.0, eps);
  DOUBLES_EQUAL(mat.b, 0.0, eps);
  DOUBLES_EQUAL(mat.c, 0.0, eps);
  DOUBLES_EQUAL(mat.d, 1.0, eps);
  DOUBLES_EQUAL(mat.tx, 0.0, eps);
  DOUBLES_EQUAL(mat.ty, 0.0, eps);
}
 
TEST(MatrixTestGroup, TestPrintMatrix) {
  std::stringstream ss;
  std::string cmp = "\n[1, 0, 0]\n[0, 1, 0]\n[0, 0, 1]\n";
  ss << mat;
  CHECK_EQUAL(ss.str(), cmp);
}
 
int main(int argc, char** argv) {
  // テストランナー
  return RUN_ALL_TESTS(argc, argv);
}
