@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         INTLIB, created 2023 by chearii         @
@    (because gamemaker numbers drive me NUTS)    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

INTLIB is a DLL containing a set of functions that handle integer conversions and comparisons.

the point of INTLIB is to provide fast and easy means of converting between the various 
integer types without messily needing to wrestle with gamemaker's real number system, which 
alternates between integers and floating-point numbers depending on the use case.

INTLIB provides the following functions in gamemaker:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    UNSIGNED INTEGER CONVERSION    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

intlib_make_u8(num): converts a gamemaker number to an unsigned 8-bit integer 
(range: 0 to 255)

intlib_make_u16(num): converts a gamemaker number to an unsigned 16-bit integer 
(range: 0 to 65535)

intlib_make_u32(num): converts a gamemaker number to an unsigned 32-bit integer 
(range: 0 to 4294967295)

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    SIGNED INTEGER CONVERSION    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

intlib_make_s8(value): converts a gamemaker number to a signed 8-bit integer 
(range: 0 to 127, -1 to -128)

intlib_make_s16(num): converts a gamemaker number to a signed 16-bit integer 
(range: 0 to 32767, -1 to -32768)

intlib_make_s32(num): converts a gamemaker number to a signed 32-bit integer 
(range: 0 to 2147483647, -1 to -2147483648)

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    DECIMAL TO FIXED-POINT    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

intlib_make_fixedpoint(value): converts a gamemaker number to a fixed-point number
(16-bit precision)

e.g. calling intlib_make_fixedpoint(1.0) will output 65536, 
     calling intlib_make_fixedpoint(0.5) will output 32768

intlib_make_fixedpoint_unsigned(value): unsigned version of intlib_make_fixedpoint

@@@@@@@@@@@@@@@@@@@@
@    COMPARISON    @
@@@@@@@@@@@@@@@@@@@@

intlib_compare(a, b): compares two gamemaker numbers as integer values

this function returns a number based on the comparison results:
0: a is less than b
1: a equals b
2: a is greater than b

intlib_compare_unsigned(a, b): unsigned version of intlib_compare

(overflow checks eventually:tm:)