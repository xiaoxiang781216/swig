/* -----------------------------------------------------------------------------
 * std_auto_ptr.i
 *
 * SWIG library file for handling std::auto_ptr.
 * Memory ownership is passed from the std::auto_ptr C++ layer to the proxy
 * class when returning a std::auto_ptr from a function.
 * Memory ownership is passed from the proxy class to the std::auto_ptr in the
 * C++ layer when passed as a parameter to a wrapped function.
 * ----------------------------------------------------------------------------- */

%define %auto_ptr(TYPE)
%typemap(in, noblock=1) std::auto_ptr< TYPE > (void *argp = 0, int res = 0) {
  res = SWIG_ConvertPtr($input, &argp, $descriptor(TYPE *), SWIG_POINTER_RELEASE);
  if (!SWIG_IsOK(res)) {
    if (res == SWIG_ERROR_RELEASE_NOT_OWNED) {
      scm_misc_error(FUNC_NAME, "Cannot release ownership as memory is not owned for argument $argnum of type 'TYPE *'", SCM_EOL);
    } else {
      %argument_fail(res, "TYPE *", $symname, $argnum);
    }
  }
  $1.reset((TYPE *)argp);
}

%typemap (out) std::auto_ptr< TYPE > %{
  %set_output(SWIG_NewPointerObj($1.release(), $descriptor(TYPE *), SWIG_POINTER_OWN));
%}

%template() std::auto_ptr< TYPE >;
%enddef

namespace std {
  template <class T> class auto_ptr {};
}
