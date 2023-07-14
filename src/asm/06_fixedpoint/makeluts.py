import math


def make_sin_lut(fractional_bits=8):
    scale = 1 << fractional_bits
    return [int(scale * math.sin(i * math.pi / 180)) for i in range(0, 360)]


def make_cos_lut(fractional_bits=8):
    scale = 1 << fractional_bits
    return [int(scale * math.cos(i * math.pi / 180)) for i in range(0, 360)]


def make_pi_lut(fractional_bits=8):
    scale = 1 << fractional_bits
    return [int(scale * i * math.pi / 180) for i in range(0, 360)]


def make_lut_string(lut: list[int], var_name: str):
    res = f"const int {var_name}[] = " + "{"
    res += ", ".join([f"{i}" for i in lut])
    res += "};\n\n"
    return res


def make_lut_hex_string(lut: list[int], var_name: str):
    lines = []
    lines.append(var_name)
    for i in range(0, 18):
        line = "    db "
        line_tokens = []
        for j in range(0, 10):
            k = i*10+j
            hex_str = f"{lut[k]:04x}"
            split_hex_str = f"${hex_str[2:]}, ${hex_str[:2]}"
            line_tokens.append(split_hex_str)
        line += ", ".join(line_tokens)
        lines.append(line)
    lines = "\n".join(lines)
    lines += "\n\n"
    return lines


if __name__ == "__main__":
    for frac in range(8, 13):
        res = ""
        res += make_lut_hex_string(make_sin_lut(frac), "_sinlu")
        res += make_lut_hex_string(make_cos_lut(frac), "_coslu")
        res += make_lut_hex_string(make_pi_lut(frac), "_angle")
        print(res)
        with open(f"lut_frac{frac}.asm", "w") as f:
            f.write(res)
