#include "geom.h"

namespace geom {
  AffineMatrix::AffineMatrix() :
    a(1.0), b(0.0), c(0.0), d(1.0), tx(0.0), ty(0.0) { }
  AffineMatrix::AffineMatrix(float a, float b, float c, float d, float tx, float ty) :
    a(a), b(b), c(c), d(d), tx(tx), ty(ty) { }
  AffineMatrix::~AffineMatrix() { }
  AffineMatrix AffineMatrix::clone() const {
    return AffineMatrix(a, b, c, d, tx, ty);
  }
  void AffineMatrix::concat(const AffineMatrix& mat) {
    a = a*mat.a + c*mat.b;
    b = b*mat.a + d*mat.b;
    c = a*mat.c + c*mat.d;
    d = d*mat.c + d*mat.d;
    tx = a*mat.tx + c*mat.ty + tx;
    ty = b*mat.tx + d*mat.ty + ty;
  }
  void AffineMatrix::translate(float dx, float dy) {
    tx = dx;
    ty = dy;
  }
  void AffineMatrix::scale(float sx, float sy) {
    a = sx;
    b = sy;
  }
  void AffineMatrix::rotate(float degree) {
    float radian = M_PI/180*degree;
    a = cos(radian);
    b = sin(radian);
    c = -sin(radian);
    d = cos(radian);
  }
  void AffineMatrix::skew(float kx, float ky) {
    b = tan(M_PI/180*ky);
    c = tan(M_PI/180*kx);
  }
  void AffineMatrix::identity() {
    a = 1.0;
    b = 0.0;
    c = 0.0;
    d = 1.0;
    tx = 0.0;
    ty = 0.0;
  }
}

std::ostream& operator<<(std::ostream& os, const geom::AffineMatrix& mat) {
  os << std::endl;
  os << "[" << mat.a << ", " << mat.c << ", " << mat.tx << "]" << std::endl;
  os << "[" << mat.b << ", " << mat.d << ", " << mat.ty << "]" << std::endl;
  os << "[0, 0, 1]" << std::endl;
  return os;
}
