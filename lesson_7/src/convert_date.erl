-module(convert_date).
-export([convert/1]).


convert(Date)->
    convert(Date,[],[],[]).
    
 convert([$/|T],Acc,Sent,Word)->
    convert(T,Acc,[list_to_integer(Word)|Sent],[]);  
convert([$:|T],Acc,Sent,Word)->
    convert(T,Acc,[list_to_integer(Word)|Sent],[]);  
convert([$ |T],Acc,Sent,Word)->
     L_reversed=lists:reverse([list_to_integer(Word)|Sent]),
    convert(T,[list_to_tuple(L_reversed)|Acc],[],[]);
convert([H|T],Acc,Sent,Word)->
    convert(T,Acc,Sent,Word++[H]);
       
convert([],Acc,Sent,Word)->
   L_reversed=lists:reverse([list_to_integer(Word)|Sent]),
   list_to_tuple(lists:reverse([list_to_tuple(L_reversed)|Acc])).

