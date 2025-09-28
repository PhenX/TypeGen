namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface IUndefinedTrait<TSpecBuilder>
{
    /// <summary>
    /// Marks the selected member as undefined (equivalent of TsUndefinedAttribute).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder Undefined();
}