export default function About(props) {
    return (
        <div className="flex flex-col items-center justify-center h-screen">
            <h1 className="text-4xl">About</h1>
            <p>
                Edit <code>src/features/About/index.jsx</code> and save to reload.
            </p>
            <a
                className="text-blue-400 hover:text-blue-200 "
                href="https://reactjs.org"
                target="_blank"
                rel="noopener noreferrer"
            >
                Learn React
            </a>
        </div>
    );
}
