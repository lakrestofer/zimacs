#ifndef LEXER_H_INCLUDED
#define LEXER_H_INCLUDED

#include <stddef.h>

// https://kubyshkin.name/posts/c-language-enums-tips-and-tricks/
#define TOKEN_ENUM(VARIANT)\
  VARIANT(INVALID) \
  VARIANT(EOF) \
  VARIANT(IDENTIFIER) \
  VARIANT(L_PAREN) \
  VARIANT(R_PAREN) \
  VARIANT(STRING)

#define TOKEN_ENUM_VARIANT(NAME) NAME,
typedef enum {
  TOKEN_ENUM(TOKEN_ENUM_VARIANT)
} TokenKind;

/// takes a pointer to the cursor pointer (such such that it can update it)
/// and a pointer
TokenKind next_token(const char **token_begin, const char** token_end);

typedef struct {
  char *ptr;
  size_t len;
} Slice;

Slice format_kind(TokenKind kind);



#endif // LEXER_H_INCLUDED
