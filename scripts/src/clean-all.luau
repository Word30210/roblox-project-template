const fs = require("@std/fs")
const process = require("@std/process")

const tint = require("@pkgs/tint")

const function clearFiles(from: string, entryName: string)
    do
        print(tint.blue("CLEAR", tint.reset.dim("deleting pesde files(*_packages)...")))

        const function clearPackages(kind: "roblox" | "luau" | "lune")
            if fs.exists(`{from}/{entryName}/{kind}_packages`) then
                const ok, result = pcall(fs.removeDirectory, `{from}/{entryName}/{kind}_packages`, { recursive = true })
                if not ok then
                    print(result)
                    print(tint.red("CLEAR", tint.reset.dim("something went wrong during clear")))
                    process.exit(1)
                end
            end
        end

        clearPackages("roblox")
        clearPackages("luau")
        clearPackages("lune")

        print(tint.green("CLEAR", tint.reset.dim("successfully deleted pesde files(*_packages)")))
    end

    if fs.exists(`{from}/{entryName}/dist`) then
        print(tint.blue("CLEAR", tint.reset.dim("deleting darklua outputs(dist)...")))

        const ok, result = pcall(fs.removeDirectory, `{from}/{entryName}/dist`, { recursive = true })
        if ok then
            print(tint.green("CLEAR", tint.reset.dim("successfully deleted darklua outputs(dist)!")))
        else
            print(result)
            print(tint.red("CLEAR", tint.reset.dim("something went wrong during clearing")))
            process.exit(1)
        end
    end
end

const function clean(target: string)
    print(tint.blue("CLEAN", tint.reset(`cleaning {target}...`)))

    const ok, entries = pcall(fs.listDirectory, target)
    if not ok then
        print(tint.red("CLEAN", tint.reset(`something went wrong during cleaning`)))
        print(entries)
        process.exit(1)
    end

    for _, entry in entries do
        if entry.type == "dir" then
            print(tint.blue("WATCH", tint.reset(`watching '{target}/{entry.name}'`)))

            clearFiles(target, entry.name)
        end
    end

    print(tint.blue("INIT", tint.reset(`successfully cleaned {target}!`)))
end

clean("places")
clean("packages")

print(tint.blue("CLEAN", tint.reset(`cleaning scripts...`)))
clearFiles(".", "scripts")
print(tint.blue("INIT", tint.reset(`successfully cleaned scripts!`)))
print(tint.green.bold("COMPLETED", tint.reset.bold("successfully cleaned!")))
