namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface IMemberNameTrait<TSpecBuilder>
{
    /// <summary>
    /// Specifies the name for the selected member (equivalent of TsMemberNameAttribute).
    /// </summary>
    /// <param name="name">The member's name.</param>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder MemberName(string name);
}