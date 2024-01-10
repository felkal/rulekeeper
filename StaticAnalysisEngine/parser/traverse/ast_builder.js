const { Graph } = require("./graph/graph");

function buildAST(originalObj) {
    const graph = new Graph();

    function traverse(obj, parentNode) {
        function mapReduce(arr, anotherParentNode) {
            return arr.map((item) => traverse(item, anotherParentNode));
        }

        if (obj === null) {
            return null;
        }

        let objNode = null;
        switch (obj.type) {
        //
        // Scripts
        //
        case "Program": {
            objNode = graph.addNode(obj.type, obj);
            graph.addStartNodes("AST", objNode);

            const resultData = mapReduce(obj.body, objNode);

            // eslint-disable-next-line no-plusplus
            for (let i = 0; i < resultData.length; i++) {
                graph.addEdge(objNode.id, resultData[i].id, { type: "AST", label: i + 1 });
            }
            break;
        }

        case "BlockStatement": {
            const resultData = mapReduce(obj.body);

            objNode = graph.addNode(obj.type, obj);

            // eslint-disable-next-line no-plusplus
            for (let i = 0; i < resultData.length; i++) {
                graph.addEdge(objNode.id, resultData[i].id, { type: "AST", label: "stmt", stmtIndex: i + 1 });
            }
            break;
        }

        //
        // Expressions
        //
        // case "ArrayExpression":
        //     const resultData = mapReduce(obj.elements);
        //     break;

        case "ObjectExpression": {
            objNode = graph.addNode(obj.type, obj);

            const resultData = mapReduce(obj.properties, objNode);

            // eslint-disable-next-line no-plusplus
            for (let i = 0; i < resultData.length; i++) {
                graph.addEdge(objNode.id, resultData[i].id, { type: "AST", label: i + 1 });
            }
            break;
        }

        case "Property": {
            objNode = graph.addNode(obj.type, obj);

            const key = traverse(obj.key, objNode);
            const computed = traverse(obj.value, objNode);

            graph.addEdge(objNode.id, key.id, { type: "AST", label: "key" });
            graph.addEdge(objNode.id, computed.id, { type: "AST", label: "computed" });
            break;
        }

        case "MemberExpression": {
            objNode = graph.addNode(obj.type, obj);

            const object = traverse(obj.object, objNode);
            const property = traverse(obj.property, objNode);

            graph.addEdge(objNode.id, object.id, { type: "AST", label: "object" });
            graph.addEdge(objNode.id, property.id, { type: "AST", label: "property" });
            break;
        }

        case "CallExpression":
        case "NewExpression": {
            objNode = graph.addNode(obj.type, obj);

            const callee = traverse(obj.callee, objNode);
            const args = mapReduce(obj.arguments, objNode);

            graph.addEdge(objNode.id, callee.id, { type: "AST", label: "callee" });

            // eslint-disable-next-line no-plusplus
            for (let i = 0; i < args.length; i++) {
                graph.addEdge(objNode.id, args[i].id, { type: "AST", label: "arg", argumentIndex: i + 1 });
            }
            break;
        }

        case "UpdateExpression":
        case "UnaryExpression": {
            objNode = graph.addNode(obj.type, obj);
            const argument = traverse(obj.argument, objNode);
            graph.addEdge(objNode.id, argument.id, { type: "AST", label: "argument" });
            break;
        }

        case "BinaryExpression":
        case "LogicalExpression":
        case "AssignmentExpression": {
            objNode = graph.addNode(obj.type, obj);

            const left = traverse(obj.left, objNode);
            const right = traverse(obj.right, objNode);

            graph.addEdge(objNode.id, left.id, { type: "AST", label: "left" });
            graph.addEdge(objNode.id, right.id, { type: "AST", label: "right" });
            break;
        }

        case "ExpressionStatement": {
            objNode = graph.addNode(obj.type, obj);

            const expression = traverse(obj.expression, objNode);
            graph.addEdge(objNode.id, expression.id, { type: "AST", label: "expression" });
            break;
        }

        case "Identifier": {
            objNode = graph.addNode(obj.type, obj);
            objNode.identifier = obj.name;
            break;
        }

        case "ArrowFunctionExpression":
        case "FunctionDeclaration":
        case "FunctionExpression":
        case "LabeledStatement": {
            objNode = graph.addNode(obj.type, obj);
            objNode.identifier = obj.id ? obj.id.name : "anon";

            const nodeParams = obj.params.map((param) => traverse(param, objNode));

            // eslint-disable-next-line no-plusplus
            for (let i = 0; i < nodeParams.length; i++) {
                graph.addEdge(objNode.id, nodeParams[i].id, { type: "AST", label: "param", paramIndex: i + 1 });
            }

            const nodeBodyStmts = traverse(obj.body, objNode); // must be blockstatement
            graph.addEdge(objNode.id, nodeBodyStmts.id, { type: "AST", label: "block" });
            break;
        }

        case "IfStatement":
        case "ConditionalExpression": {
            objNode = graph.addNode(obj.type, obj);

            const test = traverse(obj.test, objNode);
            const consequent = traverse(obj.consequent, objNode);
            const alternate = traverse(obj.alternate, objNode);

            graph.addEdge(objNode.id, test.id, { type: "AST", label: "test" });

            if (Array.isArray(consequent)) {
                const consequentNode = graph.addNode(obj.consequent.type, obj.consequent);
                // eslint-disable-next-line no-plusplus
                for (let i = 0; i < consequent.length; i++) {
                    graph.addEdge(consequentNode.id, consequent[i].id, { type: "AST", label: i + 1 });
                }
                graph.addEdge(objNode.id, consequentNode.id, { type: "AST", label: "then" });
            } else {
                graph.addEdge(objNode.id, consequent.id, { type: "AST", label: "then" });
            }

            if (alternate) {
                if (Array.isArray(alternate)) {
                    const alternateNode = graph.addNode(obj.alternate.type, obj.alternate);
                    // eslint-disable-next-line no-plusplus
                    for (let i = 0; i < alternate.length; i++) {
                        graph.addEdge(alternateNode.id, alternate[i].id, { type: "AST", label: i + 1 });
                    }
                    graph.addEdge(objNode.id, alternateNode.id, { type: "AST", label: "else" });
                } else {
                    graph.addEdge(objNode.id, alternate.id, { type: "AST", label: "else" });
                }
            }
            break;
        }

        case "ReturnStatement":
        case "ThrowStatement": {
            objNode = graph.addNode(obj.type, obj);

            const argument = traverse(obj.argument, objNode);

            if (argument) {
                graph.addEdge(objNode.id, argument.id, { type: "AST", label: "argument" });
            }
            break;
        }

        case "VariableDeclaration": {
            objNode = traverse(obj.declarations[0], parentNode);
            break;
        }

        case "VariableDeclarator": {
            objNode = graph.addNode(obj.type, obj);
            objNode.identifier = obj.id.name;
            const initNode = traverse(obj.init, objNode);

            // graph.addEdge(objNode.id, id_node.id, { type: "AST", label: 'id'});

            if (initNode) {
                graph.addEdge(objNode.id, initNode.id, { type: "AST", label: "init" });
            }
            break;
        }

        default:
            objNode = graph.addNode(obj.type, obj);
        }

        return objNode;
    }

    traverse(originalObj);
    return graph;
}

module.exports = { buildAST };
