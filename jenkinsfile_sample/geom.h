#ifndef GEOM_H
#define GEOM_H

#include <cmath>
#include <sstream>

/**
 * affine transform matrix
 * | a c tx |
 * | b d ty |
 * | 0 0  1 |
 **/
namespace geom {
  class AffineMatrix {
  public:
    float a, b, c, d, tx, ty;
    AffineMatrix();
    AffineMatrix(float a, float b, float c, float d, float tx, float ty);
    virtual ~AffineMatrix();
    AffineMatrix clone() const;
    void concat(const AffineMatrix& mat);
    void translate(float dx, float dy);
    void scale(float sx, float sy);
    void rotate(float degree);
    void skew(float kx, float ky);
    void identity();
  };
}

std::ostream& operator<<(std::ostream& os, const geom::AffineMatrix& mat);

#endif