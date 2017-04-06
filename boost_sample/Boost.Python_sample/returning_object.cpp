#include <vector>
#include <boost/python.hpp>
#include <boost/python/suite/indexing/vector_indexing_suite.hpp>


class foo {
public:
  typedef std::vector<int> int_vector;

public:
  int_vector get_list() const {
    return v_;
  }

  void add(int v) {
    v_.push_back(v);
  }

private:
  int_vector v_;
};

BOOST_PYTHON_MODULE(returning_object)
{
  using namespace boost::python;

  class_<foo>("foo")
    .def("get_list", &foo::get_list)
    .def("add", &foo::add)
    ;

  class_<foo::int_vector>("int_vector")
    .def("__getitem__", (int const&(foo::int_vector::*)(foo::int_vector::size_type) const)&foo::int_vector::at, return_value_policy<copy_const_reference>())
    .def("__len__", &foo::int_vector::size)
    ;
}
