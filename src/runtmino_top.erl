%%% @doc
%%% Runtmino top-level HTTP request handler.
%%% @end

-module(runtmino_top).
-vsn("0.1.0").
-behavior(cowboy_handler).
-author("einariii").
-copyright("einariii").
-license("MIT").

-export([init/2]).


-spec init(Req, State) -> Result
    when Req      :: cowboy_req:req(),
         State    :: any(),
         Result   :: {ok, Reply, NewState}
                   | {module(), Reply, NewState, Options},
         Reply    :: cowboy_req:req(),
         NewState :: any(),
         Options  :: any().

init(Req, State) ->
    Hits =
        case runtmino_state:read(hits) of
            {ok, N} -> N;
            error   -> 1
        end,
    ok = runtmino_state:save(hits, Hits + 1),
    Code = 200,
    Headers = #{<<"content-type">> => <<"text/plain">>},
    TextHits = integer_to_binary(Hits),
    Body =
        <<"Hello, World!\r\n",
          "We've had ", TextHits/binary, " hits so far.">>,
    Reply = cowboy_req:reply(Code, Headers, Body, Req),
    {ok, Reply, State}.
