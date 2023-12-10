"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.makeEveryOtherGenerator = exports.makeGenerator = exports.visit = exports.evaluate = void 0;
var isNode = function (node) { return !!(node === null || node === void 0 ? void 0 : node.type); };
var isTraversable = function (node) { return isNode(node) || Array.isArray(node); };
var evaluate = function (ast, visitors) {
    var visit = function (node) {
        var visitor = visitors[node.type];
        if (!visitor) {
            throw new Error("No evaluate() visitor for " + node.type);
        }
        return visitors[node.type](node, visit);
    };
    return visit(ast);
};
exports.evaluate = evaluate;
var makePath = function (node, parent, parentPath, key, index) { return ({
    node: node,
    parent: parent,
    parentPath: parentPath,
    key: key,
    index: index,
    skip: function () {
        this.skipped = true;
    },
    remove: function () {
        this.removed = true;
    },
    replaceWith: function (replacer) {
        this.replaced = replacer;
    },
    findParent: function (test) {
        return !parentPath
            ? parentPath
            : test(parentPath)
                ? parentPath
                : parentPath.findParent(test);
    },
}); };
/**
 * Apply the visitor pattern to an AST that conforms to this compiler's spec
 */
var visit = function (ast, visitors) {
    var visitNode = function (node, parent, parentPath, key, index) {
        var _a;
        var visitor = visitors[node.type];
        var path = makePath(node, parent, parentPath, key, index);
        if (visitor === null || visitor === void 0 ? void 0 : visitor.enter) {
            visitor.enter(path);
            if (path.removed) {
                if (!key || !parent) {
                    throw new Error("Asked to remove " + node.id + " but no parent key was present in " + (parent === null || parent === void 0 ? void 0 : parent.id));
                }
                if (typeof index === 'number') {
                    parent[key].splice(index, 1);
                }
                else {
                    parent[key] = null;
                }
                return path;
            }
            if (path.replaced) {
                if (!key || !parent) {
                    throw new Error("Asked to remove " + node.id + " but no parent key was present in " + (parent === null || parent === void 0 ? void 0 : parent.id));
                }
                if (typeof index === 'number') {
                    parent[key].splice(index, 1, path.replaced);
                }
                else {
                    parent[key] = path.replaced;
                }
            }
            if (path.skipped) {
                return path;
            }
        }
        Object.entries(node)
            .filter(function (_a) {
            var nodeKey = _a[0], nodeValue = _a[1];
            return isTraversable(nodeValue);
        })
            .forEach(function (_a) {
            var nodeKey = _a[0], nodeValue = _a[1];
            if (Array.isArray(nodeValue)) {
                for (var i = 0, offset = 0; i - offset < nodeValue.length; i++) {
                    var child = nodeValue[i - offset];
                    var res = visitNode(child, node, path, nodeKey, i - offset);
                    if (res === null || res === void 0 ? void 0 : res.removed) {
                        offset += 1;
                    }
                }
            }
            else {
                visitNode(nodeValue, node, path, nodeKey);
            }
        });
        (_a = visitor === null || visitor === void 0 ? void 0 : visitor.exit) === null || _a === void 0 ? void 0 : _a.call(visitor, path);
        // visitor?.exit?.(node, parent, key, index);
    };
    return visitNode(ast);
};
exports.visit = visit;
/**
 * Stringify an AST
 */
var makeGenerator = function (generators) {
    var gen = function (ast) {
        return typeof ast === 'string'
            ? ast
            : ast === null || ast === undefined
                ? ''
                : Array.isArray(ast)
                    ? ast.map(gen).join('')
                    : ast.type in generators
                        ? generators[ast.type](ast)
                        : "NO GENERATOR FOR " + ast.type + ast;
    };
    return gen;
};
exports.makeGenerator = makeGenerator;
var makeEveryOtherGenerator = function (generate) {
    var everyOther = function (nodes, eo) {
        return nodes.reduce(function (output, node, index) {
            return output +
                generate(node) +
                (index === nodes.length - 1 ? '' : generate(eo[index]));
        }, '');
    };
    return everyOther;
};
exports.makeEveryOtherGenerator = makeEveryOtherGenerator;
