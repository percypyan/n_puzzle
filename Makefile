# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/11/23 14:01:57 by parchimb          #+#    #+#              #
#    Updated: 2020/02/16 17:56:49 by parchimb         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# # # # # # # # # # # # # # #
#     DEFINED VARIABLES     #
# # # # # # # # # # # # # # #

NAME = n_puzzle
PACKAGE_NAME = NPuzzle
CC = swift

# # # # # # # # #
#     RULES     #
# # # # # # # # #

all: debug

debug:
	@echo "Start a debug build."
	swift build
	cp .build/debug/$(PACKAGE_NAME) $(NAME)

release:
	@echo "Start a release build."
	swift build -c release
	cp .build/release/$(PACKAGE_NAME) $(NAME)

clean:
	rm -rf .build

fclean: clean
	rm -f $(NAME)

dclean:
	rm -rf Packages

re: fclean all

.PHONY: all clean fclean dclean re
