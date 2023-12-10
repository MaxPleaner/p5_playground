"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var generator_1 = __importDefault(require("./parser/generator"));
var parser_1 = __importDefault(require("./parser/parser"));
module.exports = { generate: generator_1.default, parser: parser_1.default };
