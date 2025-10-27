module BookBuilder
using JSON
using Base64
using ProgressMeter

function @main(args)
    config = Dict(split.(args, '='))
    root = get(config, "root", "")
    optimize = parse(Bool, get(config, "optimize", "true"))
    @info "running with config" root optimize

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
                compile_file(files[i]; prev, next, root, optimize)
            end
        end
        isdir("build") && rm("build"; recursive = true)
        cp(joinpath(wd, "build"), "build")
        cp(joinpath(wd, "src", "resources"), joinpath("build", "resources"))
    end

    return nothing
end

function compile_file(file; prev, next, root, optimize)
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
                open(`typst compile - "{p}".png`; write = true) do io
                    write(io, example.code)
                end
                pngs = readdir()
                open(`typst compile - composed.png`; write = true) do io
                    write(io, compose_code(example, pngs))
                end
                if optimize
                    run(`oxipng -q composed.png`)
                end
            end
            mv(joinpath(temp_example_dir, "composed.png"), joinpath("src", "$(example.id).png"))
        end
    end
    run(`typst compile --root . --features html --format html $infile result.html --input book-images=created --input book-prev=$prev --input book-next=$next --input book-root=$root`)
    mv("result.html", outfile)
end

function read_outline()
    files = JSON.parse(read(`typst query --root . --field dest src/outline.typ link`))
end

compose_code(example, pngs) = """
    #set page(width: auto, height: auto, margin: 1cm, fill: $(example.bgcolor))
    #grid(
        columns: $(example.columns),
        gutter: 1cm,
        $(["image(\"$png\")," for png in pngs]...)
    )
"""

end # module BookBuilder
