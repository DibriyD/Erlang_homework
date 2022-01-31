-module(lesson3_task4).
-export([decode/1]).

decode(Json)->
    decode(Json,[],[]).

decode_quote(<<H,$',Rest/binary>>,Acc)->
    [Rest,<<Acc/binary,H>>];
decode_quote(<<H,Rest/binary>>,Acc) ->
    decode_quote(Rest,<<Acc/binary,H>>).

   
     
decode(<<H,Rest/binary>>,Acc,Obj)->
    case {H,Rest} of 
        {32,_} -> decode(Rest,Acc,Obj);
        {$",_} -> decode(Rest,Acc,Obj);
        {$',_} -> [R,Word]=decode_quote(Rest,<<>>),
                  decode(R,Acc,Obj ++Word);
        {${,_} -> [R,A]=decode(Rest,[],[]),
        	   decode(R,Acc++ [A],[]);
         {$},<<>>} -> 
        		if 
        		Obj==[]-> [Rest,Acc];
        		Obj=/=[] -> [Rest,Acc++[Obj]]
        		end; 	   

        {$,,_}-> if 
        		Obj==[]->  decode(Rest,Acc,[]);
        		Obj=/=[] ->  decode(Rest,Acc ++ [Obj],[])
        		end; 
        {$:,_} -> [R,A]=decode_obj(Rest,[],[]), 
        	   decode(R,Acc++ [list_to_tuple([Obj]++A)],[]);
	{$},_} -> if 
        		Obj==[]-> [Rest,Acc];
        		Obj=/=[] -> [Rest,Acc++[Obj]]
        		end; 
	               
	{$],_} -> if 
			Obj==[]-> [Rest,Acc];
			Obj=/=[] -> [Rest,Acc++[Obj]]
			end; 
	{$\n,_} -> decode(Rest,Acc,Obj);
        {_,_} -> decode(Rest,Acc,string:strip(Obj++ [H]))
        end;

decode(<<>>,[Acc],[])->
       Acc.
        
        
decode_obj(<<H,Rest/binary>>,Acc,Obj)->
    case {H,Rest} of
        {32,_} -> decode_obj(Rest,Acc,Obj);
        {$',_} -> [R,Word]=decode_quote(Rest,<<>>),
                  decode_obj(R,Acc,Obj ++Word);
        {$,,_}-> [Rest,Acc ++ [Obj] ];
        {${,_} -> [R,A]=decode(Rest,[],[]),
        	   [R,[A]];
        {$},<<>>}-> [<<H,Rest/binary>>,Acc ++ [Obj] ];
        {$},_} -> [<<H,Rest/binary>>,Acc++[Obj]];
        
        
        {$[,_} -> [R,A]=decode(Rest,[],[]),
        	   [R,[A]];
         {$],_} -> [<<H,Rest/binary>>,Acc++[Obj]];	   
        {_,_} -> decode_obj(Rest,Acc,string:strip(Obj++ [H]))
        end.
        
        
        
        

% {
%'squadName': 'Super hero squad',
%'homeTown': 'Metro City',
% 'formed': 2016,
%  'secretBase': 'Super tower',
% 'active': true,
% 'members': [
% {
% 'name': 'Molecule Man',
% 'age': 29,
% 'secretIdentity': 'Dan Jukes',
% 'powers': [
% 'Radiation resistance',
% 'Turning tiny',
% 'Radiation blast'
% ]
% },
% {
% 'name': 'Madame Uppercut',
% 'age': 39,
% 'secretIdentity': 'Jane Wilson',
% 'powers': [
% 'Million tonne punch',
% 'Damage resistance',
% 'Superhuman reflexes'
% ]
% },
% {
% 'name': 'Eternal Flame',
% 'age': 1000000,
% 'secretIdentity': 'Unknown',
% 'powers': [
% 'Immortality',
% 'Heat Immunity',
% 'Inferno',
% 'Teleportation',
% 'Interdimensional travel'
% ]
% }
% ]
% }

