:- dynamic(class/6).
:- dynamic(classroom/4).
:- dynamic(user/4).
:- use_module(library(strings)).
:- ensure_loaded('dados.pl').
:- ensure_loaded('repository/save.pl').
:- ensure_loaded('repository/utils-classroom.pl').
:- ensure_loaded('validacao.pl').
:- ensure_loaded('schedule.pl').
:- ensure_loaded('interfaces/userInterface.pl').
:- consult('rules/users.pl').
:- consult('rules/classes.pl').
:- encoding(utf8).

main :-
    user_screen.