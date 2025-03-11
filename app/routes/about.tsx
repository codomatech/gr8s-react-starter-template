import type { Route } from "./+types/home";

export function meta(_args: Route.MetaArgs) {
  return [
    { title: "About page" },
    { name: "description", content: "Brand new site. blank slate" },
  ];
}

export default function About() {
  return <main className="flex items-center justify-center pt-16 pb-4">
      <div className="flex-1 flex flex-col items-center gap-16 min-h-0">
        <h1>
        About Page
        </h1>
        <p>A couple of words here.</p>
      </div>
    </main>

}
