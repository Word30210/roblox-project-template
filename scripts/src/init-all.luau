const fs = require("@std/fs")
const process = require("@std/process")

const tint = require("@pkgs/tint")

const function pesdeInstall(from: string, entry: fs.DirectoryEntry)
    print(tint.blue("INSTALL", tint.reset("installing packages...")))

    const result = process.run({ "pesde", "install" }, { cwd = `{from}/{entry.name}` })
    if result.ok then
        print(result.stdout)
        print(tint.green("INSTALL", tint.reset("successfully installed packages!")))
    else
        print(result.stderr)
        print(tint.red("INSTALL", tint.reset("something went wrong during installing")))
        process.exit(1)
    end
end

const function processWithDarklua(from: string, entry: fs.DirectoryEntry)
    print(tint.blue("PROCESS", tint.reset("processing with darklua...")))

    const result = process.run({ "darklua", "process", "src", "dist" }, { cwd = `{from}/{entry.name}` })
    if result.ok then
        print(result.stdout)
        print(tint.green("PROCESS", tint.reset("successfully processed!")))
    else
        print(result.stderr)
        print(tint.red("PROCESS", tint.reset("something went wrong during the process")))
        process.exit(1)
    end
end

const function initialize(target: string)
    print(tint.blue("INIT", tint.reset(`initializing {target}...`)))

    const ok, entries = pcall(fs.listDirectory, target)
    if not ok then
        print(tint.red("INIT", tint.reset(`something went wrong during initializing`)))
        print(entries)
        process.exit(1)
    end

    for _, entry in entries do
        if entry.type == "dir" then
            print(tint.blue("WATCH", tint.reset(`watching '{target}/{entry.name}'`)))

            pesdeInstall(target, entry)
            processWithDarklua(target, entry)
        end
    end

    print(tint.blue("INIT", tint.reset(`successfully initialized {target}!`)))
end

initialize("packages")
initialize("places")

print(tint.green.bold("COMPLETED", tint.reset.bold("successfully initialized everything!")))
