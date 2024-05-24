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
     // pattern definitions
     nul = "\000";
     l_paren = "(";
     r_paren = ")";
     identifier = [a-zA-Z_/+-*]+;
     comment = [ ]*";"[^\n]*"\n";
     whitespace = [" "\n\r\t];
     string = "\""[^"]*"\"";

     // rule definitions
     l_paren { token = L_PAREN; break; }
     r_paren { token = R_PAREN; break; }
     string { token = STRING; break; }
     identifier { token = IDENTIFIER; break;}
     comment { 
       begin = cursor;
       continue; 
     }
     whitespace { 
       begin = cursor;
       continue; 
      }
     nul { token = EOF; break; }
     * { token = INVALID; break; }
   */
  }
  *token_begin = begin;
  *token_end= cursor;
  return token;
}

#define TOKEN_ENUM_SLICE(NAME) case NAME: {s.ptr = #NAME; s.len = sizeof(#NAME) - 1; break; };

Slice format_kind(TokenKind kind) {
  Slice s;
  switch (kind) {
    TOKEN_ENUM(TOKEN_ENUM_SLICE)
  }
  return s;
}
