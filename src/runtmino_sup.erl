%%% @doc
%%% Runtmino Top-level Supervisor
%%%
%%% The very top level supervisor in the system.
%%% There is only one stateful worker defined by default here, simple
%%% called [project]_state. Make it yours.
%%%
%%% See: http://erlang.org/doc/design_principles/applications.html
%%% See: http://zxq9.com/archives/1311
%%% @end

-module(runtmino_sup).
-vsn("0.1.0").
-behaviour(supervisor).
-author("einariii").
-copyright("einariii").
-license("MIT").

-export([start_link/0]).
-export([init/1]).


-spec start_link() -> {ok, pid()}.
%% @private
%% This supervisor's own start function.

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).


-spec init([]) -> {ok, {supervisor:sup_flags(), [supervisor:child_spec()]}}.
%% @private
%% The OTP init/1 function.

init([]) ->
    RestartStrategy = {one_for_one, 1, 60},
    State     = {runtmino_state,
                 {runtmino_state, start_link, []},
                 permanent,
                 5000,
                 worker,
                 [runtmino_state]},
    Children  = [State],
    {ok, {RestartStrategy, Children}}.
