return {
   ['bit-and'] = { tag = "expr", contents = "(${1} & ${2})", pure = true },
   ['bit-or'] = { tag = "expr", contents = "(${1} | ${2})", pure = true },
   ['bit-xor'] = { tag = "expr", contents = "(${1} ~ ${2})", pure = true },
   ['bit-not'] = { tag = "expr", contents = "(~${1})", pure = true },
   ['shr'] = { tag = "expr", contents = "(${1} >> ${2})", pure = true },
   ['shl'] = { tag = "expr", contents = "(${1} << ${2})", pure = true },
}
