export interface Program {
    type: 'program';
    program: AstNode[];
    wsStart?: string;
    wsEnd?: string;
}
export interface AstNode {
    type: string;
    wsStart?: string;
    wsEnd?: string;
    [key: string]: any;
}
/**
 * Converts an AST to a singe value, visiting nodes and using visitor callbacks
 * to generate the node's value. TODO: Could this be done with a reducetree
 * function? Also this is different than the enter/exit visitors in the ast
 * visitor function. Can these be merged into the same strategy?
 */
export declare type NodeEvaluators = {
    [nodeType: string]: (node: AstNode, visit: (node: AstNode) => any) => any;
};
declare const evaluate: (ast: AstNode, visitors: NodeEvaluators) => any;
export declare type Path = {
    node: AstNode;
    parent: AstNode | undefined;
    parentPath: Path | undefined;
    key: string | undefined;
    index: number | undefined;
    skip: () => void;
    remove: () => void;
    replaceWith: (replacer: AstNode) => void;
    findParent: (test: (p: Path) => boolean) => Path | undefined;
    skipped?: boolean;
    removed?: boolean;
    replaced?: any;
};
export declare type NodeVisitors = {
    [nodeType: string]: {
        enter?: (p: Path) => void;
        exit?: (p: Path) => void;
    };
};
/**
 * Apply the visitor pattern to an AST that conforms to this compiler's spec
 */
declare const visit: (ast: AstNode, visitors: NodeVisitors) => Path | undefined;
export declare type NodeGenerators = {
    [nodeType: string]: (n: AstNode) => string;
};
export declare type Generator = (ast: Program | AstNode | AstNode[] | string | undefined | null) => string;
/**
 * Stringify an AST
 */
declare const makeGenerator: (generators: NodeGenerators) => Generator;
export declare type EveryOtherGenerator = (nodes: AstNode[], eo: AstNode[]) => string;
declare const makeEveryOtherGenerator: (generate: Generator) => EveryOtherGenerator;
export { evaluate, visit, makeGenerator, makeEveryOtherGenerator };
