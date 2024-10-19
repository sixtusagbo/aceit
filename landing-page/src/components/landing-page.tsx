"use client";

import { Button } from "@/components/ui/button";
import {
  GraduationCap,
  BookOpen,
  BarChart2,
  Smartphone,
  Laptop,
  SquareArrowOutUpRight,
} from "lucide-react";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";

export function LandingPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <header className="px-4 lg:px-6 h-14 flex items-center">
        <a className="flex items-center justify-center" href="/">
          <GraduationCap className="h-6 w-6 text-[#458EFF]" />
          <span className="ml-2 text-2xl font-bold text-[#458EFF]">Ace iT</span>
        </a>
        <nav className="ml-auto flex gap-4 sm:gap-6">
          <a
            className="text-sm font-medium hover:underline underline-offset-4"
            href="#features">
            Features
          </a>
          <a
            className="text-sm font-medium hover:underline underline-offset-4"
            href="#about">
            About
          </a>
          <a
            className="text-sm font-medium hover:underline underline-offset-4"
            href="#contact">
            Contact
          </a>
        </nav>
      </header>
      <main className="flex-1">
        <section className="w-full py-12 md:py-24 lg:py-32 xl:py-48">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center space-y-4 text-center">
              <div className="space-y-2">
                <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl lg:text-6xl/none">
                  Ace Your Exams with Confidence
                </h1>
                <p className="mx-auto max-w-[700px] text-gray-500 md:text-xl dark:text-gray-400">
                  Prepare effectively with Ace iT, your ultimate exam prep
                  companion. Practice with past questions, track your progress,
                  and master your courses.
                </p>
              </div>
              <div className="space-x-4">
                <Popover>
                  <PopoverTrigger asChild>
                    <Button className="bg-[#458EFF] text-white">
                      Download
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto">
                    <div className="text-sm font-semibold">Coming Soon!</div>
                    <p className="text-xs text-gray-500">
                      Our app is currently in development.
                    </p>
                  </PopoverContent>
                </Popover>
                <Button
                  variant="outline"
                  onClick={() => (location.href = "/#about")}>
                  Learn More
                </Button>
              </div>
            </div>
          </div>
        </section>
        <section
          id="features"
          className="w-full py-12 md:py-24 lg:py-32 bg-gray-100 dark:bg-gray-800">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl text-center mb-12">
              Key Features
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div className="flex flex-col items-center text-center">
                <BookOpen className="h-12 w-12 text-[#458EFF] mb-4" />
                <h3 className="text-xl font-bold mb-2">
                  Extensive Question Bank
                </h3>
                <p className="text-gray-500 dark:text-gray-400">
                  Access a wide range of past exam questions across various
                  subjects and levels.
                </p>
              </div>
              <div className="flex flex-col items-center text-center">
                <Smartphone className="h-12 w-12 text-[#458EFF] mb-4" />
                <h3 className="text-xl font-bold mb-2">Interactive Quizzes</h3>
                <p className="text-gray-500 dark:text-gray-400">
                  Test your knowledge with engaging quizzes that offer instant
                  feedback.
                </p>
              </div>
              <div className="flex flex-col items-center text-center">
                <BarChart2 className="h-12 w-12 text-[#458EFF] mb-4" />
                <h3 className="text-xl font-bold mb-2">Result Analysis</h3>
                <p className="text-gray-500 dark:text-gray-400">
                  Monitor your performance with detailed analytics to identify
                  strengths and areas for improvement.
                </p>
              </div>
            </div>
          </div>
        </section>
        <section id="about" className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <div className="grid gap-10 lg:grid-cols-2 lg:gap-20">
              <div className="space-y-4">
                <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl">
                  About Ace iT
                </h2>
                <p className="text-gray-500 dark:text-gray-400">
                  Ace iT is an educational app designed to help you prepare
                  effectively for your exams. Built with Flutter and powered by
                  Firebase, our app provides a seamless and intuitive experience
                  across all devices.
                </p>
                <ul className="grid gap-2">
                  <li className="flex items-center gap-2">
                    <Smartphone className="h-4 w-4" /> Built with Flutter for
                    cross-platform compatibility
                  </li>
                  <li className="flex items-center gap-2">
                    <Laptop className="h-4 w-4" /> Firebase Cloud Firestore for
                    real-time data synchronization
                  </li>
                  <li className="flex items-center gap-2">
                    <BookOpen className="h-4 w-4" /> Firebase Auth for secure
                    user authentication
                  </li>
                </ul>
              </div>
              <div className="flex items-center justify-center">
                <iframe
                  width="100%"
                  height="315"
                  src="https://www.youtube.com/embed/m3l03bvvRfo?si=rOu9Nyjg3V-Yp8rp"
                  title="YouTube video player"
                  frameBorder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                  referrerPolicy="strict-origin-when-cross-origin"
                  allowFullScreen></iframe>
              </div>
            </div>
          </div>
        </section>
        <section
          id="contact"
          className="w-full py-12 md:py-24 lg:py-32 bg-gray-100 dark:bg-gray-800">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center space-y-4 text-center">
              <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl">
                  Get in Touch
                </h2>
                <p className="max-w-[600px] text-gray-500 md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed dark:text-gray-400">
                  Have questions or feedback? We'd love to hear from you!
                </p>
              </div>
              <div className="w-full max-w-sm space-y-2">
                <a
                  className="flex justify-center items-center bg-[#458EFF] text-white py-2 text-center rounded-md"
                  href="mailto:miracleagbosixtus@gmail.com">
                  <span className="pr-2">Reach out</span>
                  <SquareArrowOutUpRight className="h-4 w-4" />
                </a>
              </div>
            </div>
          </div>
        </section>
      </main>
      <footer className="flex flex-col gap-2 sm:flex-row py-6 w-full shrink-0 items-center px-4 md:px-6 border-t">
        <p className="text-xs text-gray-500 dark:text-gray-400">
          © 2024{" "}
          <a href="/" className="text-[#458EFF]">
            Ace iT
          </a>
          . All rights reserved.
        </p>
        <nav className="sm:ml-auto flex gap-4 sm:gap-6">
          <a
            className="text-xs hover:underline underline-offset-4"
            href="/privacy-policy">
            Privacy Policy
          </a>
        </nav>
      </footer>
    </div>
  );
}
