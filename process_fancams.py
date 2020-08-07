#!/usr/bin/env python

import sys
import os
import argparse
import pathlib
import shutil
import itertools


def parse_args(args):
    parser = argparse.ArgumentParser("Process fancams into sorted folders")

    parser.add_argument(
        "--auto",
        "-a",
        action="store_true",
        default=False,
        help="Automatically process",
    )
    parser.add_argument("--group", "-g", help="Group name to search")
    parser.add_argument("--member", "-m", help="Member name to search")
    parser.add_argument("--sgroup", "-G")
    parser.add_argument("--smember", "-M")
    parser.add_argument(
        "--rootdir", "-d", default="~/video/fancams", help="Fancam root dir",
    )
    parser.add_argument(
        "--searchdir", "-S", default="~/downloads", help="Search root dir"
    )
    parser.add_argument(
        "--edit",
        "-e",
        action="store_true",
        default=False,
        help="Edit results before processing",
    )
    parser.add_argument(
        "--preview",
        "-p",
        action="store_true",
        default=False,
        help="Preview results before processing",
    )
    parser.add_argument(
        "--skipgroup", "-s", default=False, action="store_true"
    )
    parser.add_argument("--logfile", "-l", help="Log actions to file")

    return parser.parse_args()


def fmt_glob(i, j):
    return "*{}*{}*".format(i, j)


def find_vids(searchdir, member, group):
    perms = itertools.product(
        *[(i, i.lower(), i.upper()) for i in (member, group)]
    )
    g = [i for s, t in perms for i in [fmt_glob(s, t), fmt_glob(t, s)]]

    p = pathlib.Path(searchdir)
    r = [p.rglob(i) for i in g]

    return {i for s in r for i in s}


def get_alts(p):
    np = p.joinpath(".names")
    if np.exists() and not np.name.startswith("_"):
        with open(np) as f:
            alts = [i.strip() for i in f.readlines()]
    else:
        alts = []

    return [(p.name, i) for i in [p.name] + alts]


def alt_perms(p1, p2):
    a1, a2 = [get_alts(i) for i in (p1, p2)]

    return [i + j for i, j in itertools.product(a1, a2)]


def test_dir(p):
    return (
        p.is_dir()
        and not p.name.startswith("_")
        and not p.name.startswith(".")
    )


def main():
    args = parse_args(sys.argv[1:])

    search_group = args.sgroup or args.group
    search_member = args.smember or args.member

    if args.auto:
        print("Running automatic processing on {}".format(args.rootdir))

        rp = pathlib.Path(args.rootdir)

        group_dirs = [i for i in rp.iterdir() if test_dir(i)]
        member_dirs = [
            (s, i)
            for s in group_dirs
            for i in s.iterdir()
            if test_dir(i) and test_dir(s)
        ]

        searches = [i for s in member_dirs for i in alt_perms(*s)]

    else:
        print("Processing {} - {}".format(args.group, args.member))

        searches = [(args.group, search_group, args.member, search_member)]

    for g, sg, m, sm in sorted(searches):
        print()
        r = find_vids(args.searchdir, sm, sg)

        if len(r) == 0:
            print("No files found for {} ({}) - {} ({})".format(sg, g, sm, m))
            continue

        new_vid_root = os.path.join(
            args.rootdir, g.capitalize(), m.capitalize()
        )
        pathlib.Path(new_vid_root).mkdir(parents=True, exist_ok=True)

        print("Moving {} files to {}".format(len(r), new_vid_root))

        for i in r:
            new_fn = os.path.join(new_vid_root, os.path.basename(i))

            print()
            print(i)
            print("->")
            print(new_fn)

            shutil.move(i, new_fn)


if __name__ == "__main__":
    main()
