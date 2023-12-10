import { AstNode } from '../core/ast';
export interface LiteralNode extends AstNode {
    literal: string;
}
export interface VersionNode extends AstNode {
    version: LiteralNode;
    literal: string;
    value: string;
    profile: string | null;
}
export interface SegmentNode extends AstNode {
    blocks: Array<AstNode>;
}
export interface LineNode extends AstNode {
    version: string;
    literal: string;
}
export declare type Ast = {
    type: string;
    blocks: SegmentNode;
    wsEnd?: string;
};
declare const preprocessComments: (src: string) => string;
export declare type Macro = {
    args?: AstNode[];
    body: string;
};
export declare type Macros = {
    [name: string]: Macro;
};
/**
 * Perform the preprocessing logic, aka the "preprocessing" phase of the compiler.
 * Expand macros, evaluate conditionals, etc
 * TODO: Define the strategy for conditionally removing certain macro types
 * and conditionally expanding certain expressions. And take in optiona list
 * of pre defined thigns?
 * TODO: Handle __LINE__ and other constants.
 */
export declare type NodePreservers = {
    [nodeType: string]: (path: any) => boolean;
};
export declare type PreprocessorOptions = {
    defines?: {
        [definitionName: string]: object;
    };
    preserve?: NodePreservers;
    preserveComments?: boolean;
    stopOnError?: boolean;
};
declare const preprocessAst: (ast: AstNode, options?: PreprocessorOptions) => AstNode;
export { preprocessAst, preprocessComments };
