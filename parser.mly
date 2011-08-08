%{
  open Syntax
%}

%token TINT
%token TBOOL
%token TFORGET
%token TFREE
%token <Syntax.name> VAR
%token <Syntax.name> UVAR
%token <int> INT
%token TRUE FALSE
%token PLUS
%token MINUS
%token TIMES
%token EQUAL LESS
%token IF THEN ELSE
%token FUN ARROW
%token REC IS
%token COLON
%token LPAREN RPAREN
%token LET IN
%token TO
%token SEMICOLON2
%token RETURN THUNK FORCE
%token QUIT
%token USE
%token <string>STRING
%token COMMA
%token EOF
%token DATA LOLLI
%token MATCH WITH PIPE END

%start toplevel
%type <Syntax.toplevel_cmd list> toplevel

%right PIPE
%nonassoc TO 
%nonassoc LET IN
%right ARROW LOLLI
%nonassoc FUN REC IS
%nonassoc IF THEN ELSE
%nonassoc EQUAL LESS 
%left PLUS MINUS
%left TIMES
%right TFREE TFORGET

%%

toplevel:
  | EOF                      { [] }
  | lettop                   { $1 }
  | exprtop                  { $1 }
  | cmdtop                   { $1 }
  | datatop                  { $1 }

lettop:
  | def EOF                  { [$1] }
  | def lettop               { $1 :: $2 }
  | def SEMICOLON2 toplevel  { $1 :: $3 }

exprtop:
  | expr EOF                 { [Expr $1] }
  | expr SEMICOLON2 toplevel { Expr $1 :: $3 }

cmdtop:
  | cmd EOF                  { [$1] }
  | cmd SEMICOLON2 toplevel  { $1 :: $3 }

datatop:
  | DATA data EOF                 { [Data $2] }
  | DATA data SEMICOLON2 toplevel { Data $2 :: $4 }

cmd:
  | USE STRING { Use $2 }
  | QUIT       { Quit }

def: LET VAR EQUAL expr { Def ($2, $4) }

data:
  | data PIPE data               { $1 @ $3 }
  | UVAR COLON ty                { [ ($1, $3) ] }

expr:
  | app                          { $1 }
  | arith                        { $1 }
  | boolean                      { $1 }
  | LET VAR EQUAL expr IN expr   { cLet ($2, $4, $6) }
  | expr TO VAR IN expr          { To ($1, $3, $5) }
  | IF expr THEN expr ELSE expr  { cIf ($2, $4, $6) }
  | FUN VAR COLON ty ARROW expr  { Fun ($2, $4, $6) }
  | REC VAR COLON ty IS expr     { Rec ($2, $4, $6) }
  | MATCH expr WITH PIPE cases   { Case ($2, $5) }
  
cases: 
  | expr ARROW expr              { [ ($1, $3) ] }
  | cases PIPE cases             { $1 @ $3 }

app:
  | non_app                      { $1 }
  | FORCE non_app                { Force $2 }
  | RETURN non_app               { Return $2 }
  | THUNK non_app                { Thunk $2 }
  | app non_app                  { cApply ($1, $2) }
 
non_app:
  | VAR                          { Var $1 }
  | UVAR                         { Const ($1, []) }
  | TRUE                         { Const ("true", []) }
  | FALSE                        { Const ("false", []) }
  | INT                          { Int $1 }
  | LPAREN expr RPAREN           { $2 }    

arith:
  | MINUS INT           { Int (-$2) }
  | expr PLUS expr	{ Plus ($1, $3) }
  | expr MINUS expr	{ Minus ($1, $3) }
  | expr TIMES expr	{ Times ($1, $3) }

boolean:
  | expr EQUAL expr { Equal ($1, $3) }
  | expr LESS expr  { Less ($1, $3) }

ty:
  | VAR                      { VConst $1 }
  | TINT         	     { VInt }
  | TBOOL	 	     { VConst "bool" }
  | ty ARROW ty              { CArrow ($1, $3) }
  | ty LOLLI ty              { VLolli ($1, $3) }
  | TFORGET ty               { VForget $2 }
  | TFREE ty                 { CFree $2 }
  | LPAREN ty RPAREN         { $2 }

%%
