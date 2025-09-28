namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface INotStaticTrait<TSpecBuilder>
{
    /// <summary>
    /// Marks the selected member as not static (equivalent of TsNotStaticAttribute).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder NotStatic();
}