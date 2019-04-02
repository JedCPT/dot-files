"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const crypto = require("crypto");
const vscode_1 = require("vscode");
function activateTaskProvider(target) {
    const provider = {
        provideTasks: () => {
            // npm or others parse their task definitions. So they need to provide 'autoDetect' feature.
            //  e,g, https://github.com/Microsoft/vscode/blob/de7e216e9ebcad74f918a025fc5fe7bdbe0d75b2/extensions/npm/src/main.ts
            // However, cargo.toml does not support to define a new task like them.
            // So we are not 'autoDetect' feature and the setting for it.
            return createDefaultTasks(target);
        },
        resolveTask: () => undefined,
    };
    return vscode_1.tasks.registerTaskProvider('cargo', provider);
}
exports.activateTaskProvider = activateTaskProvider;
const TASK_SOURCE = 'Rust';
function createDefaultTasks(target) {
    return createTaskConfigItem().map(def => createCargoTask(def, target));
}
function createCargoTask(cfg, target) {
    const { binary, command, args, cwd, env } = cfg.execution;
    const cmdLine = `${command || binary} ${args.join(' ')}`;
    const execution = new vscode_1.ShellExecution(cmdLine, { cwd, env });
    const { definition, problemMatchers, presentationOptions, group } = cfg;
    return Object.assign({ definition, scope: target, name: definition.label, source: TASK_SOURCE, execution, isBackground: false, problemMatchers, presentationOptions: presentationOptions || {}, runOptions: {} }, { group });
}
function createTaskConfigItem() {
    const common = {
        definition: { type: 'cargo' },
        problemMatchers: ['$rustc'],
        presentationOptions: {
            reveal: vscode_1.TaskRevealKind.Always,
            panel: vscode_1.TaskPanelKind.Dedicated,
        },
    };
    return [
        Object.assign({ label: 'cargo build', execution: { command: 'cargo', args: ['build'] }, group: vscode_1.TaskGroup.Build }, common),
        Object.assign({ label: 'cargo check', execution: { command: 'cargo', args: ['check'] }, group: vscode_1.TaskGroup.Build }, common),
        Object.assign({ label: 'cargo run', execution: { command: 'cargo', args: ['run'] } }, common),
        Object.assign({ label: 'cargo test', execution: { command: 'cargo', args: ['test'] }, group: vscode_1.TaskGroup.Test }, common),
        Object.assign({ label: 'cargo bench', execution: { command: 'cargo', args: ['+nightly', 'bench'] }, group: vscode_1.TaskGroup.Test }, common),
        Object.assign({ label: 'cargo clean', execution: { command: 'cargo', args: ['clean'] } }, common),
    ];
}
// NOTE: `execution` parameters here are sent by the RLS.
function runCargoCommand(folder, execution) {
    const config = {
        label: 'run Cargo command',
        definition: { type: 'cargo' },
        execution,
        problemMatchers: ['$rustc'],
        group: vscode_1.TaskGroup.Build,
        presentationOptions: {
            reveal: vscode_1.TaskRevealKind.Always,
            panel: vscode_1.TaskPanelKind.Dedicated,
        },
    };
    const task = createCargoTask(config, folder);
    return vscode_1.tasks.executeTask(task);
}
exports.runCargoCommand = runCargoCommand;
/**
 * Starts a shell command as a VSCode task, resolves when a task is finished.
 * Useful in tandem with setup commands, since the task window is reusable and
 * also capable of displaying ANSI terminal colors. Exit codes are not
 * supported, however.
 */
function runTaskCommand({ command, args, env, cwd }, displayName, folder) {
    return __awaiter(this, void 0, void 0, function* () {
        const uniqueId = crypto.randomBytes(20).toString();
        const task = new vscode_1.Task({ label: uniqueId, type: 'setup' }, folder ? folder : vscode_1.workspace.workspaceFolders[0], displayName, TASK_SOURCE, new vscode_1.ShellExecution(`${command} ${args.join(' ')}`, {
            cwd: cwd || (folder && folder.uri.fsPath),
            env,
        }));
        return new Promise(resolve => {
            const disposable = vscode_1.tasks.onDidEndTask(({ execution }) => {
                if (execution.task === task) {
                    disposable.dispose();
                    resolve();
                }
            });
            vscode_1.tasks.executeTask(task);
        });
    });
}
exports.runTaskCommand = runTaskCommand;
//# sourceMappingURL=tasks.js.map