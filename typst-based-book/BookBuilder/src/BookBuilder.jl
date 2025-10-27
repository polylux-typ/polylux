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
                compile_file(files[i]; prev, next, root, fast)
            end
        end
        isdir("build") && rm("build"; recursive = true)
        cp(joinpath(wd, "build"), "build")
        cp(joinpath(wd, "src", "resources"), joinpath("build", "resources"))
    end

    return nothing
end

function compile_file(file; prev, next, root, fast)
    @info "compiling $file"
    infile = joinpath("src", file)
    outfile = joinpath("build", chopsuffix(file, ".typ") * ".html")
    mkpath(joinpath("build", dirname(file)))
    examples = JSON.parse(read(
        `typst query --root . --features html --field=value $infile "<book-example>"`,
    ))
    @showprogress for example in examples
        mktempdir() do temp_example_dir
            cd(temp_example_dir) do
                ppi = ifelse(fast, 10, 144)
                # open(`typst compile --ppi $ppi - "{p}".png`; write = true) do io
                open(`typst compile - "{0p}".svg`; write = true) do io
                    write(io, example.code)
                end
                imgs = readdir()
                for img in imgs
                    run(`scour -i $img -o min.svg --enable-id-stripping --enable-comment-stripping --shorten-ids --indent=none`)
                    mv("min.svg", img; force = true)
                end

                # open(`typst compile --ppi $ppi - composed.png`; write = true) do io
                open(`typst compile - composed.svg`; write = true) do io
                    write(io, compose_code(example, imgs))
                end
                # if !fast
                #     run(`oxipng -q composed.png`)
                # end
                run(`scour -i composed.svg -o composed-min.svg --enable-id-stripping --enable-comment-stripping --shorten-ids --indent=none`)
            end
            # mv(joinpath(temp_example_dir, "composed.png"), joinpath("src", "$(example.id).png"))
            mv(joinpath(temp_example_dir, "composed-min.svg"), joinpath("src", "$(example.id).svg"))
        end
    end
    run(`typst compile --root . --features html --format html $infile result.html --input book-build=true --input book-prev=$prev --input book-next=$next --input book-root=$root`)
    run(`minhtml --keep-html-and-head-opening-tags --keep-closing-tags -o result-min.html result.html`)
    mv("result-min.html", outfile)
end

function read_outline()
    files = JSON.parse(read(`typst query --root . --field dest src/outline.typ link`))
end

compose_code(example, imgs) = """
    #set page(width: auto, height: auto, margin: 1cm, fill: $(example.bgcolor))
    #grid(
        columns: $(example.columns),
        gutter: 1cm,
        $(["image(\"$img\")," for img in imgs]...)
    )
"""

end # module BookBuilder
