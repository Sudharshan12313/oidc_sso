// exports.handler = async (event) => {
//     const response = {
//         statusCode: 200,
//         body: JSON.stringify("Hello, World!"),
//     };
//     return response;
// };

exports.handler = async (event) => {
    console.log("Event: ", JSON.stringify(event, null, 2));
 
    // Extract Authorization header
    const authHeader = event.headers?.Authorization || event.headers?.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return {
            statusCode: 401,
            body: JSON.stringify({ message: "Unauthorized: No token provided" }),
        };
    }
 
    // Extract token
    const token = authHeader.split(" ")[1];
 
    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Hello, World!", token }),
    };
};
