#ifdef PERL_CORE

/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     WORD = 258,
     METHOD = 259,
     FUNCMETH = 260,
     THING = 261,
     PMFUNC = 262,
     PRIVATEREF = 263,
     FUNC0SUB = 264,
     UNIOPSUB = 265,
     LSTOPSUB = 266,
     PADBLK = 267,
     LABEL = 268,
     FORMAT = 269,
     SUB = 270,
     ANONSUB = 271,
     PACKAGE = 272,
     USE = 273,
     WHILE = 274,
     UNTIL = 275,
     IF = 276,
     UNLESS = 277,
     ELSE = 278,
     ELSIF = 279,
     CONTINUE = 280,
     FOR = 281,
     GIVEN = 282,
     WHEN = 283,
     DEFAULT = 284,
     LOOPEX = 285,
     DOTDOT = 286,
     YADAYADA = 287,
     FUNC0 = 288,
     FUNC1 = 289,
     FUNC = 290,
     UNIOP = 291,
     LSTOP = 292,
     RELOP = 293,
     EQOP = 294,
     MULOP = 295,
     ADDOP = 296,
     DOLSHARP = 297,
     DO = 298,
     HASHBRACK = 299,
     NOAMP = 300,
     LOCAL = 301,
     MY = 302,
     MYSUB = 303,
     REQUIRE = 304,
     COLONATTR = 305,
     PREC_LOW = 306,
     DOROP = 307,
     OROP = 308,
     ANDOP = 309,
     NOTOP = 310,
     ASSIGNOP = 311,
     DORDOR = 312,
     OROR = 313,
     ANDAND = 314,
     BITOROP = 315,
     BITANDOP = 316,
     SHIFTOP = 317,
     MATCHOP = 318,
     REFGEN = 319,
     UMINUS = 320,
     POWOP = 321,
     POSTDEC = 322,
     POSTINC = 323,
     PREDEC = 324,
     PREINC = 325,
     ARROW = 326,
     PEG = 327
   };
#endif

/* Tokens.  */
#define WORD 258
#define METHOD 259
#define FUNCMETH 260
#define THING 261
#define PMFUNC 262
#define PRIVATEREF 263
#define FUNC0SUB 264
#define UNIOPSUB 265
#define LSTOPSUB 266
#define PADBLK 267
#define LABEL 268
#define FORMAT 269
#define SUB 270
#define ANONSUB 271
#define PACKAGE 272
#define USE 273
#define WHILE 274
#define UNTIL 275
#define IF 276
#define UNLESS 277
#define ELSE 278
#define ELSIF 279
#define CONTINUE 280
#define FOR 281
#define GIVEN 282
#define WHEN 283
#define DEFAULT 284
#define LOOPEX 285
#define DOTDOT 286
#define YADAYADA 287
#define FUNC0 288
#define FUNC1 289
#define FUNC 290
#define UNIOP 291
#define LSTOP 292
#define RELOP 293
#define EQOP 294
#define MULOP 295
#define ADDOP 296
#define DOLSHARP 297
#define DO 298
#define HASHBRACK 299
#define NOAMP 300
#define LOCAL 301
#define MY 302
#define MYSUB 303
#define REQUIRE 304
#define COLONATTR 305
#define PREC_LOW 306
#define DOROP 307
#define OROP 308
#define ANDOP 309
#define NOTOP 310
#define ASSIGNOP 311
#define DORDOR 312
#define OROR 313
#define ANDAND 314
#define BITOROP 315
#define BITANDOP 316
#define SHIFTOP 317
#define MATCHOP 318
#define REFGEN 319
#define UMINUS 320
#define POWOP 321
#define POSTDEC 322
#define POSTINC 323
#define PREDEC 324
#define PREINC 325
#define ARROW 326
#define PEG 327



#endif /* PERL_CORE */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */

    I32	ival; /* __DEFAULT__ (marker for regen_perly.pl;
				must always be 1st union member) */
    char *pval;
    OP *opval;
    GV *gvval;
#ifdef PERL_IN_MADLY_C
    TOKEN* p_tkval;
    TOKEN* i_tkval;
#else
    char *p_tkval;
    I32	i_tkval;
#endif
#ifdef PERL_MAD
    TOKEN* tkval;
#endif



/* Line 1676 of yacc.c  */
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif




