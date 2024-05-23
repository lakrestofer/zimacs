#ifndef LEXER_H_INCLUDED
#define LEXER_H_INCLUDED

typedef enum TokenKind_e {
  INVALID,
  EOF,
  IDENTIFIER,
  L_PAREN,
  R_PAREN,
} TokenKind;

TokenKind next_token(const char** tokenizer_cursor);

#endif // LEXER_H_INCLUDED
