def append_move_comment_list(li, item):
    """Appends an item to a commented list, moving the last comment to the new last item."""
    comment = None
    i = len(li) - 1
    li.append(item)
    if i in li.ca.items:
        comment = li.ca.items[i][0]
    if comment is None:
        return
    li.ca.items[i][0] = None
    li.ca.items[i + 1] = [comment, None, None, None]


def remove_move_comment_list(li, item):
    """Removes an item from a commented list, moving the last comment to the new last item."""
    comment = None
    i = len(li) - 1
    if i in li.ca.items:
        comment = li.ca.items[i][0]
    li.remove(item)
    if comment is None:
        return
    if not li:
        return comment
    li.ca.items[i - 1] = [comment, None, None, None]


def append_move_comment_dict(di, key, value):
    """Appends an item to a commented dictionary, moving the last comment to the new last item."""
    comment = None
    if di:
        prev = next(reversed(di))
        if prev in di.ca.items:
            comment = di.ca.items[prev][2]
            di.ca.items[prev][2] = None
    di[key] = value
    if comment is None:
        return
    di.ca.items[key] = [None, None, comment, None]


def remove_move_comment_dict(di, key):
    """Removes an item from a commented dictionary, moving the last comment to the new last item."""
    comment = None
    if next(reversed(di)) == key and key in di.ca.items:
        comment = di.ca.items[key][2]
    del di[key]
    if comment is None:
        return
    if not di:
        return comment
    di.ca.items[next(reversed(di))] = [None, None, comment, None]


def preserve_comment(data, key, comment):
    """Moves a saved comment to the given key, useful when it belonged to a removed item in an above collection."""
    if key not in data.ca.items:
        data.ca.items[key] = [None, [comment], None, None]
    else:
        data.ca.items[key][1] = [comment]


def extract_comment(data):
    """Retrieves the comment from after a commented collection recursively."""
    if not isinstance(data, (dict, list)) or not data:
        return

    last_item = -1 if isinstance(data, list) else next(reversed(data))
    comment_index = 0 if isinstance(data, list) else 2

    if data.ca.items:
        last_comment_token = next(reversed(data.ca.items))
        if not data.ca.items[last_comment_token][comment_index].value.isspace():
            comment_container = data.ca.items.pop(last_comment_token)
            comment = comment_container[comment_index]
            comment.value = "\n" + comment.value.lstrip("\n")
            return comment

    return extract_comment(data[last_item])


def set_style(data, flow):
    """Sets the style of all items in a collection recursively."""
    if isinstance(data, dict):
        if flow:
            data.fa.set_flow_style()
        else:
            data.fa.set_block_style()
        for key in data:
            set_style(data[key], flow)

    elif isinstance(data, list):
        if flow:
            data.fa.set_flow_style()
        else:
            data.fa.set_block_style()
        for item in data:
            set_style(item, flow)


def str_to_bool(s):
    """Converts a given string to a boolean."""
    lower_s = s.lower()
    if lower_s not in ("true", "false"):
        fail(f'Invalid boolean value: "{s}".', 2)
    return lower_s == "true"