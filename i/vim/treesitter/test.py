@click
@decorate(x=12)
def get_model(base, /, x: int, y: int = 12, *, param1: str = "te", param2=print) -> int:
    """computes a model"""
    mult = base + x * y
    random = "test"
    if mult > 12:  # simple case
        return param1 * len(random)
    elif mult > 14:
        return param1 * 2
    else:
        mult += 1
    # this we do
    inform(12, random, choice=mult)
    nested_call(12, choice=inform(12, 14))
    (get_function() + 1)(x=12)
    use = base ** mult  # numerical
    return param2(use)  # injected


class Something(FromThere):
    def __init__(self):
        super().__init__()
        self.x = 12
