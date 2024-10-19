const PrivacyPolicy = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Privacy Policy</h1>

      <div className="space-y-4">
        <section>
          <h2 className="text-2xl font-bold mb-2">1. Introduction</h2>
          <p>
            Welcome to Ace iT ("we," "our," or "us"). We are committed to
            protecting your personal information and your right to privacy. This
            Privacy Policy explains how we collect, use, disclose, and safeguard
            your information when you use our mobile application (the "App").
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">2. Information We Collect</h2>
          <p>
            We may collect information that you provide directly to us, such as
            when you create an account, use our services, or contact us for
            support. This may include:
          </p>
          <ul className="list-disc list-inside ml-4">
            <li>Personal information (e.g., name, email address)</li>
            <li>Educational information (e.g., courses, exam history)</li>
            <li>Usage data and analytics</li>
          </ul>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">
            3. How We Use Your Information
          </h2>
          <p>We use the information we collect to:</p>
          <ul className="list-disc list-inside ml-4">
            <li>Provide, maintain, and improve our services</li>
            <li>Personalize your experience and content</li>
            <li>Communicate with you about our services</li>
            <li>Analyze usage patterns and trends</li>
          </ul>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">4. Data Security</h2>
          <p>
            We implement appropriate technical and organizational measures to
            protect your personal information against unauthorized or unlawful
            processing, accidental loss, destruction, or damage.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">5. Your Rights</h2>
          <p>
            You have the right to access, correct, or delete your personal
            information. You may also have the right to restrict or object to
            certain processing of your data.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">
            6. Changes to This Privacy Policy
          </h2>
          <p>
            We may update this Privacy Policy from time to time. We will notify
            you of any changes by posting the new Privacy Policy on this page
            and updating the "Last Updated" date.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-2">7. Contact Us</h2>
          <p>
            If you have any questions about this Privacy Policy, please contact
            us at:
            <br />
            Email:{" "}
            <a
              href="mailto:miracleagbosixtus@gmail.com"
              className="text-[#458EFF]">
              miracleagbosixtus@gmail.com
            </a>
          </p>
        </section>

        <p className="mt-8 text-sm text-gray-600">
          Last Updated: October 19, 2024
        </p>
      </div>
    </div>
  );
};

export default PrivacyPolicy;
