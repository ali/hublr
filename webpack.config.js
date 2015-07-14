module.exports = {
    context: __dirname + "/src",
    entry: {
        eventPage: "./eventPage.js",
        index: "./index.js"
    },
    output: {
        path: __dirname + "/build",
        filename: "[name].bundle.js"
    },
    module: {
        loaders: [
            // Babel
            {
                test: /\.js?$/,
                exclude: /(node_modules|bower_components)/,
                loader: "babel"
            },
            // Sass
            {test: /\.scss$/, loader: "style!css!sass"}
        ]
    }
};
