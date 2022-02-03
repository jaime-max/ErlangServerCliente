-module(servidor). 
-export([start/0,client/3]).

start() -> 
   spawn(fun() -> server(8089) end).

server(Port) ->
   {ok, Socket} = gen_udp:open(Port, [binary, {active, false}]), 
   io:format("server opened socket:~p~n",[Socket]), 
   loop(Socket). 

loop(Socket) ->
   inet:setopts(Socket, [{active, once}]), 
   receive 
      {udp, Socket, Host, Port, Bin} -> 
      io:format("servidor receive next message:~p~n",[binary_to_float(Bin)]), 
      gen_udp:send(Socket, Host, Port, Bin), 
      loop(Socket) 
   end. 

client(I,J,K) -> 
   {ok, Socket} = gen_udp:open(0, [binary]), 
   io:format("client opened socket=~p~n",[Socket]), 
   %I=60s tiempo ejecucion original
   %J=20 tiempo 1 mejora
    Franccmejora = (J/I),
    io:fwrite("~w~n", [Franccmejora]),
    %K= 12 nueva mejora de la aceleracion 20
    Speedupmejora = (J/K),
    io:fwrite("~w~n", [Speedupmejora]),
    Timejecuionmejora = I *((1-Franccmejora)+Franccmejora/ Speedupmejora),
    io:fwrite("~w~n", [Timejecuionmejora]),
    N= float_to_binary(Timejecuionmejora),
   ok = gen_udp:send(Socket, "localhost", 8089, N), Value = receive 
      {udp, Socket, _, _, Bin} ->
         io:format("client received next message:~p~n",[binary_to_float(Bin)]) after 2000 ->
      0 
   end, 
   
gen_udp:close(Socket), 
Value.