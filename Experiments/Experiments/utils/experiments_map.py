def get_experiment_number(use_case, number):
    if use_case == "leb":
        if number == 1: return 1
        elif number == 2: return 2
        elif number == 3: return 3
        elif number == 4: return 4
        elif number == 5: return 5
        else:
            print('Please provide a valid experiment number (1-5). You provided: ', number)
            return -1
    elif use_case == "habitica":
        if number == 1: return 6
        elif number == 2: return 7
        elif number == 3: return 8
        else:
            print('Please provide a valid experiment number (1-5). You provided: ', number)
            return -1
    elif use_case == "amazona":
        if number == 1: return 9
        elif number == 2: return 10
        elif number == 3: return 11
        else:
            print('Please provide a valid experiment number (1-5). You provided: ', number)
            return -1
    elif use_case == "blog":
        if number == 1: return 12
        elif number == 2: return 13
        elif number == 3: return 14
        else:
            print('Please provide a valid experiment number (1-5). You provided: ', number)
            return -1
    elif use_case == "webus":
        if number == 1: return 15
        elif number == 2: return 16
        elif number == 3: return 17
        else:
            print('Please provide a valid experiment number (1-5). You provided: ', number)
            return -1
    else:
        print('Please provide a valid use case name (leb, habitica, amazona, blog). You provided: ', use_case)
        exit()

def get_use_case_experiments(use_case):
    if use_case == "leb": return [1,2,3,4,5]
    elif use_case == "habitica": return [1,2,3]
    elif use_case == "amazona": return [1,2,3]
    elif use_case == "blog": return [1,2,3]
    else:
       print('Please provide a valid use case name (leb, habitica, amazona, blog). You provided: ', use_case)
       exit()

