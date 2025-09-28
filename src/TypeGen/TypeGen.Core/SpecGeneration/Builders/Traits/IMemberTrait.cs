namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface IMemberTrait<TSpecBuilder>
{
    /// <summary>
    /// Sets the currently configured member.
    /// </summary>
    /// <param name="memberName">The member's name.</param>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder Member(string memberName);
}