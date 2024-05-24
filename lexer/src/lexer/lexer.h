#ifndef LEXER_H_INCLUDED
#define LEXER_H_INCLUDED

#include <stddef.h>

typedef enum TokenKind_e {
  INVALID,
  EOF,
  IDENTIFIER,
  L_PAREN,
  R_PAREN,
} TokenKind;

/// takes a pointer to the cursor pointer (such such that it can update it)
/// and a pointer
TokenKind next_token(const char **token_begin, const char** token_end);

#endif // LEXER_H_INCLUDED
