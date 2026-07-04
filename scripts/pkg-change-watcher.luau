const fs = require("@std/fs")
const process = require("@std/process")
const task = require("@std/task")

const tint = require("@pkgs/tint")

const function collectDirs(root: string): { string }
	const dirs = { root }
	const ok, entries = pcall(fs.listDirectory, root)
	if ok then
		for _, entry in entries do
			if entry.type == "dir" and entry.name ~= "dist" then
				for _, sub in collectDirs(`{root}/{entry.name}`) do
					table.insert(dirs, sub)
				end
			end
		end
	end

	return dirs
end

const ok, topEntries = pcall(fs.listDirectory, "packages")
if not ok then
	print(tint.red("ERROR", tint.reset("Couldn't find 'packages/'. Run from root.")))
	process.exit(1)
end

const watchers: { [string]: typeof(fs.watch("")) } = {}
const watchPkg: { [string]: string } = {}

for _, entry in topEntries do
	if entry.type == "dir" then
		const pkg = entry.name
		for _, dir in collectDirs(`packages/{pkg}`) do
			const wok, watcher = pcall(fs.watch, dir)
			if wok then
				watchers[dir] = watcher
				watchPkg[dir] = pkg
			end
		end
	end
end

while true do
	local sawAny = false
	for dir, watcher in watchers do
		const event = watcher:next()
		if event then
			sawAny = true
			const pkg = watchPkg[dir]
			print(tint.blue("CHANGE", tint.reset(`pkg={pkg} change={event.change} rename={event.rename}`)))

			const result = process.run({ "darklua", "process", "src", "dist" }, { cwd = `packages/{pkg}` })
			print(tint.blue.dim("DARKLUA::EXITCODE", tint.reset.dim(tostring(result.exitcode))))
			print(tint.blue.dim("DARKLUA::OK", tint.reset.dim(tostring(result.ok))))
			print(tint.blue.dim("DARKLUA::STDERR", tint.reset.dim(tostring(result.stderr))))
			print(tint.blue.dim("DARKLUA::STDOUT", tint.reset.dim(tostring(result.stdout))))
		end
	end

	if not sawAny then
		task.wait(0.01)
	end
end
