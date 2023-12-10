"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var ast_1 = require("./ast");
test('visit()', function () {
    var tree = {
        type: 'root',
        left: {
            type: 'ident',
            identifier: 'a',
        },
        right: {
            type: 'group',
            expression: {
                type: 'ident',
                identifier: 'b',
            },
        },
    };
    var found1;
    var found2;
    var unfound;
    (0, ast_1.visit)(tree, {
        ident: {
            enter: function (path) {
                var _a, _b;
                var node = path.node;
                if (node.identifier === 'b') {
                    found1 = (_a = path.findParent(function (_a) {
                        var node = _a.node;
                        return node.type === 'root';
                    })) === null || _a === void 0 ? void 0 : _a.node;
                    found2 = (_b = path.findParent(function (_a) {
                        var node = _a.node;
                        return node.type === 'group';
                    })) === null || _b === void 0 ? void 0 : _b.node;
                }
            },
        },
    });
    expect(found1).not.toBeNull();
    expect(found1 === null || found1 === void 0 ? void 0 : found1.type).toBe('root');
    expect(found2).not.toBeNull();
    expect(found2 === null || found2 === void 0 ? void 0 : found2.type).toBe('group');
    expect(unfound).not.toBeDefined();
});
