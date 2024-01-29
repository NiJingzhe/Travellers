extends Resource
class_name Stack

var stack = []

func push(item):
    stack.append(item)

func pop():
    if not is_empty():
        var item = peek()
        stack.remove_at(len(stack) - 1)
        return item

func peek():
    if not is_empty():
        return stack[len(stack) - 1]

func is_empty():
    return len(stack) == 0

func size():
    return len(stack)
