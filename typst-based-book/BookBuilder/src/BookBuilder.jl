module BookBuilder
using JSON
using Base64
using ProgressMeter

function @main(args)
    config = Dict(split.(args, '='))
    root = get(config, "root", "")
    fast = parse(Bool, get(config, "fast", "false"))
    @info "running with config" root fast

    mktempdir() do wd
        cp("src", joinpath(wd, "src"))
        cd(wd) do
            files = read_outline()
            for i in eachindex(files)
                prev = next = ""
                if i > firstindex(files)
                    prev = files[i - 1]
                end
                if i < lastindex(files)
                    next = files[i + 1]
                end
                compile_file(files[i]; prev, next, root, fast, pageid = "page$i")
            end
        end
        isdir("build") && rm("build"; recursive = true)
        cp(joinpath(wd, "build"), "build")
        cp(joinpath(wd, "src", "resources"), joinpath("build", "resources"))
    end

    return nothing
end

const SCOUR_FLAGS = [
    "--enable-id-stripping",
    "--enable-comment-stripping",
    "--shorten-ids",
    "--indent=none",
]

function compile_file(file; prev, next, root, fast, pageid)
    @info "compiling $file"
    infile = joinpath("src", file)
    outfile = joinpath("build", chopsuffix(file, ".typ") * ".html")
    mkpath(joinpath("build", dirname(file)))
    examples = JSON.parse(read(
        ```
        typst query
            --root .
            --features html
            --field value
            $infile
            "<book-example>"
        ```,
    ))
    @showprogress for example in examples
        for theme in ("light", "dark")
            mktempdir() do temp_example_dir
                cd(temp_example_dir) do
                    open(
                        io -> write(io, example.code),
                        ```
                        typst compile - "{0p}".svg --input theme=$theme
                        ```;
                        write = true
                    )
                    pages = readdir()
                    for page in pages
                        run(`scour $page min.svg $SCOUR_FLAGS`)
                        mv("min.svg", page; force = true)
                    end

                    open(
                        io -> write(io, compose_code(example, pages)),
                        `typst compile - composed.svg`;
                        write = true
                    )
                    run(`scour composed.svg composed-min.svg $SCOUR_FLAGS`)
                end
                mv(
                    joinpath(temp_example_dir, "composed-min.svg"),
                    joinpath("build", "$pageid-$(example.id)-$theme.svg");
                    force = true
                )
            end
        end
    end
    run(```
        typst compile
            --root .
            --features html
            --format html
            $infile result.html
            --input book-build=true
            --input book-page-id=$pageid
            --input book-prev=$prev
            --input book-next=$next
            --input book-root=$root
    ```)
    run(```
        minhtml
            --keep-html-and-head-opening-tags
            --keep-closing-tags
            -o result-min.html
            result.html
    ```)
    mv("result-min.html", outfile)
end

read_outline() = JSON.parse(read(```
    typst query
        --root .
        --field dest
        src/outline.typ
        link
```))

compose_code(example, imgs) = """
    #set page(
        width: auto,
        height: auto,
        margin: 1cm,
        fill: none,
    )
    #show image: box.with(
        stroke: 1mm + $(example.bgcolor),
        inset: 0pt,
        radius: 2mm,
        clip: true,
    )
    #grid(
        columns: $(example.columns),
        gutter: 1cm,
        $(["image(\"$img\")," for img in imgs]...)
    )
"""

end # module BookBuilder
