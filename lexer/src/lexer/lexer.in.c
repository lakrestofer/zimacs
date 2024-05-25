#include "lexer.h"

// we disable the fill api and set the macro values
/*!re2c
  re2c:yyfill:enable = 0;
  re2c:define:YYCTYPE = char;
  re2c:define:YYCURSOR = cursor;
  re2c:define:YYMARKER = marker;
*/

TokenKind next_token(const char **token_begin, const char** token_end) {
  const char *begin = *token_begin; // pointer to the beginning of the token
  const char *cursor = *token_end; // pointer to the end of the token
  char *marker = (char*) cursor;
  TokenKind token = INVALID;

  for (;;) {
  /*!re2c
    // ==== pattern definitions ====
      // util
      nul = "\000";
      // == delimiters ==
      l_paren = "(";
      r_paren = ")";
      l_vec_paren = "#(";
      l_byte_vec_paren = "#u8(";
      identifier = [a-zA-Z_/+-*]+;
      // == skipped tokens ==
      comment = [ ]*";"[^\n]*"\n";
      whitespace = [" "\n\r\t];
      //  == literals ==
      string = "\""[^"]*"\"";
      boolean = "#t"|"#f"|"#true"|"#false";
      // numbers
      sign = "" | "+" | "-";
      exactness = "" | "#i" | "#e";
      radix2 = "#b";
      radix8 = "#o";
      radix10 = ""|"#d";
      radix16 = "#x";
      digit10 = [0123456789];
      digit2 = [01];
      digit8 = [01234567];
      digit16 = digit10 | [abcdef] | [ABCDEF];
      infnan = "+inf.0" | "-inf.0" | "+nan.0" | "-nan.0";
      suffix = "" | "e" sign digit10;
      prefix10 = radix10 exactness | exactness radix10;
      prefix2 = radix2 exactness | exactness radix2;
      prefix8 = radix8 exactness | exactness radix8;
      prefix16 = radix16 exactness | exactness radix16;
      uinteger10 = digit10+;
      uinteger2 = digit2+;
      uinteger8 = digit8+;
      uinteger16 = digit16+;
      decimal10 = uinteger10 suffix | "." digit10+ suffix | digit10+ "." digit10* suffix;
      ureal10 = uinteger10 | uinteger10 "/" uinteger10 | decimal10;
      ureal2 = uinteger2 | uinteger2 "/" uinteger2;
      ureal8 = uinteger8 | uinteger8 "/" uinteger8;
      ureal16 = uinteger16 | uinteger16 "/" uinteger16;
      real10 = sign ureal10 | infnan;
      real2 = sign ureal2 | infnan;
      real8 = sign ureal8 | infnan;
      real16 = sign ureal16 | infnan;
      complex_common = infnan "i" | "+" "i" | "-" "i";
      complex10 = real10 | real10 "@" real10 | real10 "+" ureal10 "i" | real10 "-" ureal10 "i" | real10 "+" "i" | real10 "-" "i" | real10 infnan "i" | "+" ureal10 "i" | "-" ureal10 "i" | complex_common;
      complex2 = real2 | real2 "@" real2 | real2 "+" ureal2 "i" | real2 "-" ureal2 "i" | real2 "+" "i" | real2 "-" "i" | real2 infnan "i" | "+" ureal2 "i" | "-" ureal2 "i" | complex_common;
      complex8 = real8 | real8 "@" real8 | real8 "+" ureal8 "i" | real8 "-" ureal8 "i" | real8 "+" "i" | real8 "-" "i" | real8 infnan "i" | "+" ureal8 "i" | "-" ureal8 "i" | complex_common;
      complex16 = real16 | real16 "@" real16 | real16 "+" ureal16 "i" | real16 "-" ureal16 "i" | real16 "+" "i" | real16 "-" "i" | real16 infnan "i" | "+" ureal16 "i" | "-" ureal16 "i" | complex_common;
      num10 = prefix10 complex10;
      num2 = prefix2 complex2;
      num8 = prefix8 complex8;
      num16 = prefix16 complex16;
      number = num10 | num2 | num8 | num16;
      
      // ==== rule definitions ====
      // delimiters
      l_paren { token = L_PAREN; break; }
      r_paren { token = R_PAREN; break; }
      l_vec_paren { token = L_VEC_PAREN; break; }
      l_byte_vec_paren { token = L_BYTE_VEC_PAREN; break; }
      // literals
      string { token = STRING; break; }
      boolean { token = BOOLEAN; break; }
      number { token = NUMBER; break; }
      identifier { token = IDENTIFIER; break;}
      // skipped tokens
      comment { 
        begin = cursor;
        continue; 
      }
      whitespace { 
        begin = cursor;
        continue; 
      }
      // invalid / end of input
      nul { token = EOF; break; }
      * { token = INVALID; break; }
   */
  }
  *token_begin = begin;
  *token_end= cursor;
  return token;
}

// macro that takes a enum, and creates a struct containing a c-string and its length
#define TOKEN_ENUM_SLICE(NAME) case NAME: {s.ptr = #NAME; s.len = sizeof(#NAME) - 1; break; };

Slice format_kind(TokenKind kind) {
  Slice s;
  switch (kind) {
    TOKENS(TOKEN_ENUM_SLICE)
  }
  return s;
}
