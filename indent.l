datatype   (static|const|unsigned|long|[ ]*)*[ ]*(int|float|char|double)
name       [a-zA-Z_][a-zA-Z0-9_]*
number     [0-9][0-9\.Ee]*
anything    .
%{
     char    TOKEN_STRING[200];
     
%}

%%
				/* Skip all spaces , tab & newline */
[\t \n]			;
                /* Regexp for including Header file */
[#][ ]*include[ ]*[\<][ ]*[a-z]+[\.][h][ ]*[\>]             { 
																int j = 0;
																int i = 0;
																for( i = 0;i < strlen(yytext); i++ )
	 															{
	 																if(yytext[i]!=' ')
	 																TOKEN_STRING[j++]=yytext[i];
	 															}
	 															TOKEN_STRING[j]='\0';
																yylval.sval=TOKEN_STRING;
																return  HEADER;
															}															

[#][ ]*include[ ]*[\"][ ]*[a-z]+[\.][h][ ]*[\"]             { 
																int j = 0;
																int i = 0;
																for( i = 0;i < strlen(yytext); i++ )
	 															{
	 																if(yytext[i]!=' ')
	 																TOKEN_STRING[j++]=yytext[i];
	 															}
	 															TOKEN_STRING[j]='\0';
																yylval.sval=TOKEN_STRING;
																return  HEADER;
															}
                             

([\(][ ]*({datatype}[ ]*{name}[ ]*[,]?[ ]*)+[\)])|([\(][ ]*[\)])                                   {
																		int j=0;
																		int i=0;
																		int flag = 1;
																		for(i = 0;i < strlen(yytext); i++)
																		{
                                                                           if(yytext[i]==' '&&flag==1)
                                                                           {
                                                                                TOKEN_STRING[j++]=yytext[i];
                                                                                flag = 0;
                                                                           }
                                                                           else if(yytext[i]!=' ' && yytext[i]!=',')
                                                                           {
                                                                           	if(yytext[i]!='(' && yytext[i]!= ')')
                                                                           	{
                                                                           	   TOKEN_STRING[j++]=yytext[i];
                                                                           	    flag = 1;
                                                                            }
                                                                            else if(yytext[i] == '(')
                                                                            {
                                                                            	TOKEN_STRING[j++] = '(';
                                                                            	TOKEN_STRING[j++] = ' ';
                                                                            	flag = 0;
                                                                            }
                                                                            else if(yytext[i]==')')
                                                                            {
                                                                            	if(yytext[i-1]!=' ')
                                                                            	  TOKEN_STRING[j++]=' ';
                                                                            	TOKEN_STRING[j++] = ')';
                                                                            	flag = 0;
                                                                            }

                                                                           }
                                                                           else if(yytext[i]==',')
                                                                           {
                                                                           	if(yytext[i-1]!=' ')
                                                                           	  TOKEN_STRING[j++]=' ';
                                                                           	TOKEN_STRING[j++]=',';
                                                                           	TOKEN_STRING[j++]=' ';
                                                                           	flag = 0;
                                                                           } 
																		}
																		TOKEN_STRING[j] = '\0';
																		yylval.sval = TOKEN_STRING;
																		return ARGUMENT;

                                                                   }
                                 /* Handle the data_type and remove redundant spaces*/
{datatype}                                                        {
																		int j = 0;
																		int i = 0;
																		int flag = 1;
																		if(yytext[0]==' ')
																		 flag = 0;
																		for(i = 0;i < strlen(yytext); i++)
																		{
                                                                           if(yytext[i]==' '&&flag==1)
                                                                           {
                                                                                TOKEN_STRING[j++]=yytext[i];
                                                                                flag = 0;
                                                                           }
                                                                           else if(yytext[i]!=' ')
                                                                           {
                                                                           	TOKEN_STRING[j++]=yytext[i];
                                                                           	flag = 1;
                                                                           } 
																		}
																		TOKEN_STRING[j] = '\0';
																		yylval.sval = TOKEN_STRING;
																		return DATATYPE;

                                                                     }
[\(]({anything}*[;]{anything}*[;]{anything}*)[\)]                      {
                                                                        strcpy(TOKEN_STRING, yytext);
	                                                                    yylval.sval = TOKEN_STRING;
	                                                                    return FOR_ARGUMENT;
                                                                    }
for                                                                 {
                                                                       strcpy(TOKEN_STRING,yytext);
                                                                        yylval.sval = TOKEN_STRING;
                                                                        return FOR;
                                                                     }
break                                                                 {
                                                                       strcpy(TOKEN_STRING,yytext);
                                                                        yylval.sval = TOKEN_STRING;
                                                                        return BREAK;
                                                                     }
else[ ]*if                                                        {
                                                                      int i = 0;
                                                                      int j = 0;
                                                                      int flag = 1;
                                                                      for(i=0;i<strlen(yytext);i++)
                                                                      {
                                                                      	if(yytext[i]!=' ')
                                                                      	{
                                                                            TOKEN_STRING[j++]=yytext[i];
                                                                      	}
                                                                      	else if(yytext[i]==' '&& flag == 1)
                                                                      	{
                                                                            TOKEN_STRING[j++] = yytext[i];
                                                                            flag = 0;
                                                                      	}
                                                                      }
                                                                      TOKEN_STRING[j] = '\0';
                                                                      yylval.sval = TOKEN_STRING;
                                                                        return BLOCK_TYPE;

                                                                  }
(while|if)                                                        {
                                                                        strcpy(TOKEN_STRING,yytext);
                                                                        yylval.sval = TOKEN_STRING;
                                                                        return BLOCK_TYPE;
                                                                    }
do                                                                {
                                                                       strcpy(TOKEN_STRING,yytext);
                                                                        yylval.sval = TOKEN_STRING;
                                                                        return DO;
                                                                     }
else                                                                {
                                                                       strcpy(TOKEN_STRING,yytext);
                                                                        yylval.sval = TOKEN_STRING;
                                                                        return ELSE;
                                                                     }
                                                                
switch                                                              {return SWITCH;}                                       
case                                                                {return CASE;}
default                                                             {return DEFAULT;}
[\(]({anything})*[\)]                                       { 
                                                                        strcpy(TOKEN_STRING, yytext);
	                                                                    yylval.sval = TOKEN_STRING;
	                                                                    return CALL_ARGUMENT;
                                                                }

{number}                                                            {
	                                                                   strcpy(TOKEN_STRING, yytext);
	                                                                    yylval.sval = TOKEN_STRING;
	                                                                    return NUMBER;
                                                                     }

{name}																{
	                                                                    strcpy(TOKEN_STRING, yytext);
	                                                                    yylval.sval = TOKEN_STRING;
	                                                                    return NAME;

	                                                                }
"<="            return LE;
">="            return GE;
"=="            return EQ;
"!="            return NE;
"||"            return OR;
"&&"            return AND;                                                    
.               return yytext[0];


%%
