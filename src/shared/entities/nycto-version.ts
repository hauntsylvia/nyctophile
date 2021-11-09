class NyctoVersion
{
    major: number
    minor: number
    build: number
    revision: number
    constructor(major: number, minor: number, build: number, revision: number)
    {
        this.major = major
        this.minor = minor
        this.build = build
        this.revision = revision
    }
}
export { NyctoVersion }